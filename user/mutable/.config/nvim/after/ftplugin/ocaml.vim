silent! unmap <buffer> <LocalLeader>t
silent! unmap <buffer> <LocalLeader>s
silent! unmap <buffer> <LocalLeader>S
silent! unmap <buffer> <LocalLeader>p
silent! unmap <buffer> <LocalLeader>n
silent! unmap <buffer> <LocalLeader>c
silent! unmap <buffer> <LocalLeader>C
silent! unmap <buffer> gd
nmap <silent> <buffer> gh <Plug>OCamlSwitchEdit
nnoremap <silent> <buffer> gt :MerlinTypeOf<CR>
vnoremap <silent> <buffer> gt :MerlinTypeOfSel<CR>
nnoremap <silent> <buffer> gd :MerlinLocate<CR>
nnoremap <silent> <buffer> <F3> :MerlinErrorCheck<CR>
set commentstring=(*%s*)
