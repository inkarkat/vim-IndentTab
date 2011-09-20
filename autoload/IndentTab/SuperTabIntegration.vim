function! IndentTab#SuperTabIntegration#GetExpr()
    return (exists('g:indenttab') || exists('b:indenttab') ? IndentTab#Tab() : "\<Tab>")
endfunction
