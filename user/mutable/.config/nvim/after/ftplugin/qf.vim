" Both location list and quickfix list have filetype of qf
setlocal nowrap
setlocal signcolumn=no
setlocal nolist
setlocal norelativenumber
setlocal nonumber
set nobuflisted
set colorcolumn=
nnoremap <buffer> q  ZZ
autocmd BufEnter <buffer> if winnr('$') < 2 | q | endif
