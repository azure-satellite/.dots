silent! unmap <buffer> \
silent! unmap <buffer> <space>
silent! unmap <buffer> <C-l>
nmap <buffer> <silent> o <Plug>(vimfiler_toggle_mark_current_line)
nmap <buffer> <silent> <TAB> <Plug>(vimfiler_choose_action)
nmap <buffer> <silent> u <Plug>(vimfiler_switch_to_parent_directory)
