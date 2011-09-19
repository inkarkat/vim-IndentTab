" IndentTab.vim: Use tabs for indent at the beginning, spaces for alignment in
" the rest of a line. 
"
" DESCRIPTION:
"   This script allows you to use your normal tab settings ('tabstop',
"   'smarttabstop', 'expandtab') for the beginning of the line (up to the first
"   non-whitespace character), and have <Tab> expanded to the appropriate
"   number of spaces (i.e. like ':set expandtab') anywhere else.
"   This effectively distinguishes "indenting" from "alignment"; the characters
"   inserted by <Tab> depend on the local context. 
" 
" USAGE:
"   <Tab>		Uses normal tab settings at the beginning of the line
"			(before the first non-whitespace character), and inserts
"			spaces otherwise.
"   <BS>		Uses normal tab settings to delete tabs at the beginning
"			of the line; elsewhere it also removes "space-expanded"
"			tabs as if 'softtabstop' were enabled. 
"
" INSTALLATION:
" DEPENDENCIES:
" CONFIGURATION:
" INTEGRATION:
" LIMITATIONS:
" ASSUMPTIONS:
" KNOWN PROBLEMS:
" TODO:
"
" Copyright: (C) 2008-2011 by Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Sources: 
"  - vimscript#231 ctab.vim by Michael Geddes. 
"  - http://vim.wikia.com/wiki/Converting_tabs_to_spaces
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"	003	20-Sep-2011	Add flag g:indenttab / b:indenttab for
"				statusline and "supertab" integrations. 
"				Expose mapping result functions for "supertab"
"				integrations through IndentTab#GetExpr(). 
"       002     12-Jun-2009     Implemented switching from indenting to
"				alignment when a single <Space> has been
"				entered. 
"	001	20-Aug-2008	file creation

function! IndentTab#Tab()
    let l:textBeforeCursor = strpart(getline('.'), 0, col('.') - 1)
    if &l:expandtab || l:textBeforeCursor =~ (&l:softtabstop ? '^\s*$' : '^\t*$')
	" If 'expandtab' is on, Vim will do the translation to spaces for us. 
	" In the whitespace-only indent section of the line return the ordinary
	" <Tab>. Settings like 'softtabstop' are then handled by Vim as if there
	" were not mapping for <Tab>.
	" For 'softtabstop', "whitespace" means <Tab> and <Space> (which must be
	" included because part of the indent can consist of spaces), but only
	" <Tab> when 'softtabstop' is off. This way, one can switch from
	" indenting to alignment (e.g. when continuing a multi-line statement)
	" by inserting a single <Space>, and can then finish the alignment
	" conveniently by pressing <Tab>. 
	return "\<Tab>"
    endif

    " For the space-only text section of the line, determine and return the
    " correct amount of spaces. 
    let l:indent = (&l:softtabstop == 0 ? &l:tabstop : &l:softtabstop)

    " Note: The simple virtcol('.') is wrong when the character under the cursor
    " is a <Tab>, ! isprint character (e.g. ^V) or double-width character (e.g.
    " a Japanese Kanji), because virtcol() returns the _last_ virtual column
    " occupied.
    " What is needed here is the _first_ virtual column of the cursor. Since we
    " cannot move the cursor to the left within this function, we use the
    " virtcol([line, col]) function and determine the (last) virtual column of
    " the character before the cursor to which we only have to add 1 to get to
    " the first column of the cursor. To determine the (start) column of the
    " character before the cursor, we subtract the length of the character
    " before the cursor from the overall length up to the cursor.
    " (Alternatively, this could also be done via a match with the \%<c regexp
    " item.)
    "let l:colBeforeCursor = strlen(matchstr(l:textBeforeCursor, '^.*\%<' . col('.') . 'c')) + 1
    let l:colBeforeCursor = strlen(l:textBeforeCursor) - strlen(matchstr(l:textBeforeCursor, '.$')) + 1
    let l:virtCol = virtcol([line('.'), l:colBeforeCursor]) + 1

    let l:off = l:virtCol % l:indent
    let l:off = (l:off ? l:off : l:indent)
"****D echomsg '****' l:virtCol . ' '. virtcol('.')  . ' ' . l:off . ' ' . (l:indent - l:off + 1)
    return repeat(' ', l:indent - l:off + 1)
endfunction
function! IndentTab#Backspace()
    let l:textBeforeCursor = strpart(getline('.'), 0, col('.') - 1)

    " Return the ordinary <BS> if we're not deleting a <Space> or if we're in
    " the whitespace-only indent section of the line. 
    let l:charBeforeCursor = matchstr(l:textBeforeCursor, '.$')
    if l:charBeforeCursor != ' ' || l:textBeforeCursor =~ '^\s*$'
	return "\<BS>"
    endif

    " In the space-only text section of the line, let Vim do the deletion of the
    " correct amount of spaces by temporarily turning on 'expandtab' and
    " 'softtabstop', if not already enabled. This relieves us from calculating
    " the correct amount of <BS> keys (which also depend on the 'softtabstop'
    " setting). 
    if &l:expandtab && l:softtabstop
	return "\<BS>"
    else
	let l:tempOn  = "\<C-\>\<C-o>:set" . (&l:expandtab ? '' : ' et')   . (&l:softtabstop ? '' : ' sts=' . &l:tabstop) . "\<CR>"
	let l:tempOff = "\<C-\>\<C-o>:set" . (&l:expandtab ? '' : ' noet') . (&l:softtabstop ? '' : ' sts=0')             . "\<CR>"
	return l:tempOn . "\<BS>" . l:tempOff
    endif
endfunction

" The context tab can be en-/disabled globally or only for a particular buffer. 
function! IndentTab#Switch( isTurnOn, isGlobal )
    let l:mappingScope = (a:isGlobal ? '' : '<buffer>')
    let l:flagScope    = (a:isGlobal ? 'g' : 'b')

    if a:isTurnOn
	if ! g:IndentTab_IsSuperTab
	    execute 'inoremap ' . l:mappingScope . ' <expr> <Tab> IndentTab#Tab()'
	endif
	execute 'inoremap ' . l:mappingScope . ' <expr> <BS>  IndentTab#Backspace()'

	execute 'let' l:flagScope . ":indenttab = 'all'"
    else
	if ! g:IndentTab_IsSuperTab
	    execute 'silent! ' . l:mappingScope . ' iunmap <Tab>'
	endif
	execute 'silent! ' . l:mappingScope . ' iunmap <BS>'

	execute 'unlet!' l:flagScope . ':indenttab'
    endif
endfunction

" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
