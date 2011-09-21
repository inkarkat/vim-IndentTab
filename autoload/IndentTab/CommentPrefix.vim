" CommentPrefix.vim: IndentTab detection of comment prefix scope. 
"
" DEPENDENCIES:
"
" Copyright: (C) 2011 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"	001	21-Sep-2011	file creation

function! s:Literal( string )
" Helper: Make a:string a literal search expression. 
    return '\V\C' . escape(a:string, '\') . '\m'
endfunction
function! s:IsComment( prefix )
    return &l:comments =~# '\%(^\|,\)[^:]*:' . s:Literal(a:prefix) . '\%(,\|$\)'
endfunction
function! IndentTab#CommentPrefix#IsIndentAfterCommentPrefix( textBeforeCursor )
    let l:prefix = get(matchlist(a:textBeforeCursor, '^\(\S\+\)' . (&l:softtabstop ? '\s*$' : '\t*$')), 1, '')
    return (! empty(l:prefix) && s:IsComment(l:prefix))
endfunction

" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
