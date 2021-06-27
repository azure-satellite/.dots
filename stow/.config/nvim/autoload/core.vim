function! core#is_file_like()
    return empty(&buftype) || &buftype ==# 'acwrite' || &buftype ==# 'nowrite'
endfunction

function! core#statusline_file()
  let l:file = expand(@%)
  if get(g:, 'loaded_conflicted')
    let l:version = trim(ConflictedVersion())
    if !empty(l:version) && l:version !=? 'working'
      return l:version
    else
      return l:file
    endif
  else
    return l:file
  endif
endfunction

function! core#statusline_branch()
    " Uncomment to not show branch info on buffers that aren't tracked, but it
    " will also not show branch info on buffers outside vim's pwd
    " if get(b:, 'tracked') && get(g:, 'loaded_fugitive') && empty(&buftype)
    if get(g:, 'loaded_fugitive') && core#is_file_like() && !empty(bufname(''))
        let branch = fugitive#head(6)
        return empty(branch) ? '' : '  שׂ '.branch.' '
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

function! core#statusline_lsp() abort
  let sl = ''
  if luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
    let errors = luaeval('vim.lsp.diagnostic.get_count(0, [[Error]])')
    if errors > 0
      let sl .= 'ﰸ '.errors.' '
    endif
    let warnings = luaeval('vim.lsp.diagnostic.get_count(0, [[Warning]])')
    if warnings > 0
      let sl .= ' '.warnings.' '
    endif
    let hints = luaeval('vim.lsp.diagnostic.get_count(0, [[Hint]])')
    if hints > 0
      let sl .= ' '.hints.' '
    endif
  endif
  return sl
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

function! core#mv(files, dest)
  let dest = fnameescape(a:dest)
  for file in a:files
    let from = fnameescape(file)
    let to = dest . fnamemodify('/'.trim(from, '/'), ':t')
    let code = rename(from, to)
    if code == -1
      echoe 'Failed moving ' . from . ' to ' . to
    endif
  endfor
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

" Execute command and output result at cursor
function! core#out(cmd) abort
  let lines = [a:cmd] + split(execute(a:cmd), '\n')
  let start = line('.') - 1
  let end = start + len(lines)
  call nvim_buf_set_lines(0, start, end, 0, lines)
endfunction

" vim: fdm=indent
