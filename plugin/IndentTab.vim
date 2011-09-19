" IndentTab.vim: Use tabs for indent at the beginning, spaces for alignment in
" the rest of a line. 
"
" DEPENDENCIES:
"
" Copyright: (C) 2008-2011 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"	001	20-Sep-2011	Enable supertab integrations through
"				g:IndentTab_IsSuperTab (which disables the
"				remapping of <Tab>). 
"				file creation

" Avoid installing twice or when in unsupported Vim version. 
if exists('g:loaded_IndentTab') || (v:version < 700)
    finish
endif
let g:loaded_IndentTab = 1

if ! exists('g:IndentTab_IsSuperTab')
    let g:IndentTab_IsSuperTab = 0
endif

" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
