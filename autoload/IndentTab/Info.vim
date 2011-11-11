" IndentTab/Info.vim: IntentTab activation information for use in statusline
" etc. 
"
" DEPENDENCIES:
"
" Copyright: (C) 2011 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"	001	22-Sep-2011	file creation

function! IndentTab#Info#indenttab()
    if exists('b:indenttab')
	return b:indenttab
    elseif exists('g:indenttab')
	return g:indenttab
    else
	return 0
    endif
endfunction

" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
