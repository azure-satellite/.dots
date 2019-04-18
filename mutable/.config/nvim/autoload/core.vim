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

function! core#colors()
    hi! Normal guibg=NONE
    " hi! Normal guibg=NONE guifg=NONE
    " hi TabLine guibg=black
    " hi TabLineSel guibg=black
    " hi TabLineFill guibg=black
    " hi! link StatusLine TabLineSel
    " hi! link StatusLineNC TabLineFill
    " hi DiffAdd guibg=NONE gui=bold
    " hi DiffDelete guibg=NONE gui=bold
    " hi DiffText gui=bold
    " hi! clear DiffChange
    " hi! NonText guifg=#657B83 guibg=NONE
    " hi! link EndOfBuffer NonText
    " hi! LineNr guibg=#011c24
    " hi! link Folded LineNr
    " hi! link SignColumn LineNr
    " hi! Search guibg=#124356 guifg=#8CDCB7 gui=underline,bold
    " hi! link IncSearch Search
    " hi Pmenu gui=bold
    " hi PmenuSel gui=bold,reverse
    " hi! link PmenuSBar Pmenu
    " " If I link User1 to StatusLineNC I will get empty colors on inactive windows
    " hi! link User1 TablineSel
    " hi! User2 guifg=black guibg=#586e75
    " hi! User3 guifg=black guibg=#839496
    " hi! Comment gui=NONE
endfunction

function! core#statusline_branch()
    let s = ''
    " Uncomment to not show branch info on buffers that aren't tracked, but it
    " will also not show branch info on buffers outside vim's pwd
    " if get(b:, 'tracked') && get(g:, 'loaded_fugitive') && empty(&buftype)
    if get(g:, 'loaded_fugitive') && empty(&buftype)
        let s = fugitive#head()
        let s = !empty(s) ? '('.s.') ' : ''
    endif
    return s
endfunction

function! core#is_file_like()
    return empty(&buftype) || &buftype ==# 'acwrite' || &buftype ==# 'nowrite'
endfunction

function! core#statusline_filesize()
    return core#is_file_like() ? '[' . core#filesize() . '] ' : ''
endfunction

function! core#statusline_flags()
    let r = ''
    if core#is_file_like()
        let r .= &modified ? '[+]' : ''
        let r .= &readonly ? '[RO]' : ''
        let r .= &paste ? '[P]' : ''
    endif
    return r
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

" vim: fdm=indent
