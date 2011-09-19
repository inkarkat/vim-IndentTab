function! IndentTab#Info#indenttab()
    if exists('b:indenttab')
	return b:indenttab
    elseif exists('g:indenttab')
	return g:indenttab
    else
	return ''
    endif
endfunction
function! IndentTab#Info#IsEnabled()
    return (! empty(IndentTab#Info#indenttab()))
endfunction
