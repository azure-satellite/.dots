let s:versions = ['working', 'upstream', 'local']

function! s:Conflicted()
  args `git diff --name-only --diff-filter=U`
  set tabline=%!ConflictedTabline()
  call s:Merger()
endfunction

function! s:Merger()
  " Shim to support Fugitive 3.0 and prior versions
  if exists(':Gvdiffsplit')
    Gvdiffsplit!
  else
    Gdiff
  endif

  call s:SetVersionStatuslines()
  call s:TabEdit('upstream')
  call s:TabEdit('local')
  tabfirst
endfunction

function! ConflictedTabline()
  let s = ''
  for tabnr in range(tabpagenr('$'))
    if tabnr + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif
    let s .= '%' . (tabnr + 1) . 'T'
    let s .= ' %{ConflictedTabLabel(' . tabnr . ')} '
  endfor
  let s .= '%#TabLineFill#%T'
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999X'
  endif
  return s
endfunction

function! ConflictedTabLabel(tabnr)
  return (a:tabnr + 1) . ': [' . s:versions[a:tabnr] . ']'
endfunction

function! s:TabEdit(parent)
  Gtabedit :1
  let b:conflicted_version = 'base'
  diffthis
  execute 'Gvsplit :' . s:VersionNumber(a:parent)
  let b:conflicted_version = a:parent
  diffthis
  wincmd r
endfunction

function! s:SetVersionStatuslines()
  let b:conflicted_version = 'working'
  wincmd h
  let b:conflicted_version = 'upstream'
  wincmd l
  wincmd l
  let b:conflicted_version = 'local'
  wincmd h
endfunction

function! s:VersionNumber(version)
  return index(s:versions, a:version) + 1
endfunction

command! Conflicted call <sid>Conflicted()
