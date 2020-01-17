function! core#strip_whitespace()
    " Strip trailing whitespace
    " preparation. save last search, and cursor position.
    let l:s = @/
    let l:l = line('.')
    let l:c = col('.')
    " do the business:
    %s/\s\+$//e
    " clean up: restore previous search history, and cursor position
    let @/ = l:s
    call cursor(l:l, l:c)
endfunction

function! core#windo(command)
    " Like windo but restore the current window.
    set lazyredraw
    let l:win = winnr()
    execute 'windo ' . a:command
    execute l:win . 'wincmd w'
    set nolazyredraw
endfunction

function! core#bufdo(command)
    " Like bufdo but restore the current buffer.
    set lazyredraw
    let l:buf = bufnr('%')
    execute 'bufdo ' . a:command
    execute 'buffer ' . l:buf
    set nolazyredraw
endfunction

function! core#tabdo(command)
    " Like tabdo but restore the current tab.
    set lazyredraw
    let l:tab = tabpagenr()
    execute 'tabdo ' . a:command
    execute 'tabn ' . l:tab
    set nolazyredraw
endfunction

function! core#argdo(command)
    " Like argdo but restore the current buffer.
    set lazyredraw
    let l:buf = bufnr('%')
    execute 'argdo ' . a:command
    execute 'buffer ' . l:buf
    set nolazyredraw
endfunction

function! core#cabbrev(target, ...)
    if a:0 == 0
        echoe 'Missing RHS of command'
        return 1
    endif
    let lhs = matchlist(a:target, '\v(\w+)%(\[(\w+)\])?')
    let rhs = join(a:000)
    let s:abbr = {val -> printf('cabbrev %s <C-R>=(getcmdtype() == ":" && getcmdpos() == 1 ? "%s" : "%s")<CR>', val, rhs, val)}
    let i = 0
    while i <= strwidth(lhs[2])
        exe s:abbr(lhs[1] . strcharpart(lhs[2], 0, i))
        let i += 1
    endwhile
endfunction

function! core#set_indent(num)
    execute 'set tabstop='.a:num
    execute 'set shiftwidth='.a:num
    execute 'set softtabstop='.a:num
endfunction

function! core#vsetsearch(cmdtype)
    let l:reg = @"
    normal! gvy
    let @/ = '\V' . substitute(escape(@", a:cmdtype.'\'), '\n', '\\n', 'g')
    let @" = l:reg
endfunction

function! core#is_file_like()
    return empty(&buftype) || &buftype ==# 'acwrite' || &buftype ==# 'nowrite'
endfunction

function! core#statusline_branch()
    " Uncomment to not show branch info on buffers that aren't tracked, but it
    " will also not show branch info on buffers outside vim's pwd
    " if get(b:, 'tracked') && get(g:, 'loaded_fugitive') && empty(&buftype)
    if get(g:, 'loaded_fugitive') && core#is_file_like() && !empty(bufname(''))
        let branch = fugitive#head()
        return empty(branch) ? '' : '▏'.branch.' '
    endif
    return ''
endfunction

function! core#statusline_filesize()
    return core#is_file_like() ? '[' . core#filesize() . '] ' : ''
endfunction

function! core#statusline_flags()
    if core#is_file_like() && !empty(bufname(''))
        let r = ''
        let r .= &modified ? '[+]' : ''
        let r .= &readonly ? '[RO]' : ''
        let r .= &paste ? '[P]' : ''
        return r
    endif
    return ''
endfunction

function! core#statusline_linter()
    let s = ''
    if get(g:, 'loaded_ale') && 
     \ get(g:, 'ale_enabled') &&
     \ get(b:, 'ale_enabled', 1) &&
     \ index(g:ale_filetype_blacklist, &filetype) == -1 &&
     \ empty(&buftype)
        let s = ale#statusline#Count(bufnr('%'))
        let s = (s.error   ? printf('%se ', s.error) : '') .
              \ (s.warning ? printf('%sw ', s.warning) : '') .
              \ (s.info    ? printf('%si ', s.info) : '')
        if empty(s)
            let s = '▏OK '
        else
            let s = '▏LINT('.s[:-2].') '
        endif
    endif
    return s
endfunction

function! core#statusline_git()
    let s = ''
    if get(b:, 'tracked') && exists('b:gitgutter') && has_key(b:gitgutter, 'summary') && empty(&buftype)
        let s = b:gitgutter.summary
        let s = (s[0] ? printf('%s+ ', s[0]) : '') .
              \ (s[1] ? printf('%s~ ', s[1]) : '') .
              \ (s[2] ? printf('%s! ', s[2]) : '')
        let s = empty(s) ? '' : 'GIT('.s[:-2].')▕ '
    endif
    return s
endfunction

function! core#filesize() abort
    let l:bytes = getfsize(expand('%p'))
    if (l:bytes >= 1024)
        let l:kbytes = l:bytes / 1025
    endif
    if (exists('kbytes') && l:kbytes >= 1000)
        let l:mbytes = l:kbytes / 1000
    endif
    if l:bytes <= 0
        return '0'
    endif
    if (exists('mbytes'))
        return l:mbytes . 'M'
    elseif (exists('kbytes'))
        return l:kbytes . 'K'
    else
        return l:bytes . 'B'
    endif
endfunction

function! core#tabline()
    let s = ''
    for l:i in range(tabpagenr('$'))
        let s .= l:i + 1 == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'
        let s .= '%' . (l:i + 1) . 'T'
	    let s .= ' BUF(' . join(sort(tabpagebuflist(l:i + 1)), ',') . ')▕'
    endfor
    let s .= '%#TabLineFill#%T'
    let s .= '%=%#TabLine#%999X'
    let s .= '%#TabLineSel#'
    let s .= '▏'.getcwd().'▕ '
    let s .= 'BUFL('.len(getbufinfo({'buflisted':1})).')▕ '
    let s .= 'ARGL('.len(argv()).') '
    return s
endfunction

" Return the text covered by a motion after an operator
function! core#operated_text(wise)
    " TODO: Remove dependency on operator_user
    let l:sel = &selection
    let &selection = 'inclusive'
    let l:reg = @"
    let l:v = operator#user#visual_command_from_wise_name(a:wise)
    execute printf('normal! `[%s`]y', l:v)
    let l:text = @"
    let &selection = l:sel
    let @" = l:reg
    return l:text
endfunction

function! core#centered_floating_window(border)
    let width = min([&columns - 4, max([80, &columns - 20])])
    let height = min([&lines - 4, max([20, &lines - 10])])
    let top = ((&lines - height) / 2) - 1
    let left = (&columns - width) / 2
    let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}

    if a:border == v:true
        let top = "╭" . repeat("─", width - 2) . "╮"
        let mid = "│" . repeat(" ", width - 2) . "│"
        let bot = "╰" . repeat("─", width - 2) . "╯"
        let lines = [top] + repeat([mid], height - 2) + [bot]
        let s:buf = nvim_create_buf(v:false, v:true)
        call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
        call nvim_open_win(s:buf, v:true, opts)
        set winhl=Normal:Normal
        let opts.row += 1
        let opts.height -= 2
        let opts.col += 2
        let opts.width -= 4
        call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
        au BufWipeout <buffer> exe 'bw '.s:buf
    else
        call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    endif
endfunction

" vim: fdm=indent
