set nolist
nnoremap <silent> <buffer> q :q!<CR>
setlocal nomodifiable
" Search |link| and 'option'
nnoremap <silent> <buffer> i :call search('''[A-Za-z0-9_-]\{2,}''')<CR>
nnoremap <silent> <buffer> I :call search('''[A-Za-z0-9_-]\{2,}''', 'b')<CR>
nnoremap <silent> <buffer> o :call search('<bar>[^ <bar>]\+<bar>')<CR>
nnoremap <silent> <buffer> O :call search('<bar>[^ <bar>]\+<bar>', 'b')<CR>
