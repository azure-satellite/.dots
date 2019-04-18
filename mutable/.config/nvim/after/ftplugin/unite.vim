silent! nunmap <buffer> k
silent! nunmap <buffer> j
nnoremap <buffer> <C-h> :tabprevious<CR>
nnoremap <buffer> <C-l> :tabnext<CR>
imap <buffer> jk <Plug>(unite_insert_leave)
imap <buffer> <ESC> <Plug>(unite_insert_leave)
