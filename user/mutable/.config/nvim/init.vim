scriptencoding utf-8

" Functions {{{1

" Transform script function name into one that can be called from outside
function! s:sid(funcname) " {{{2
    let prefix = matchstr(expand('<sfile>'), '<SNR>\d\+_\zesid$')
    return printf('%s%s', prefix, a:funcname)
endfun

" Options {{{1

" Has to come before any <leader> mappings
let mapleader='\'
" Defaults for all the files
set tabstop=2
set shiftwidth=2
set softtabstop=2
set noswapfile
" Always show the sign column
set signcolumn=auto
set completeopt-=preview
set mouse=
set spellfile=
" q: When joining multiple lines, don't move the cursor all the way to the end
set cpoptions+=q
" Substitute live preview
set inccommand=nosplit
" Better searching defaults
set smartcase
set ignorecase
" set nohlsearch
set nowrapscan
" Time to wait for the next key when the mapping is ambigous
set timeoutlen=3000
" Do not insert two spaces after '.' when using J
set nojoinspaces
set dictionary=/usr/share/dict/words
" Default value is '.,/usr/include,,'
set path=.,,
let &grepprg='rg --glob "!package-lock.json" --glob "!package.json" --smart-case --hidden --vimgrep $* $PWD'
set grepformat=%f:%l:%c:%m,%f:%l:%m
" Fold by indentation
au FileType * if &foldmethod ==# 'manual' | setlocal foldmethod=indent | endif
" Enable folding
set foldenable
" But set it to a high nesting value
set foldlevel=99
" Fold one liners too
set foldminlines=0
" Maximum nesting
set foldnestmax=10
" Width of text
set textwidth=80
" Soft-wrap lines
set wrap
" Break only at non-word characters (:h breakat)
set linebreak
" Every visually-indented line will have the same indent as the beginning of the
" line
set breakindent
" Unfortunately showbreak accepts a string only. If it accepted a function, we
" could conditionally set the indentation characters.
let &showbreak = '↪  '
" Round indent to multiple of shiftwidth
set shiftround
" Insert spaces instead of tabs when pressing <TAB>
set expandtab
" Dont complain when leaving buffers with changes
set hidden
" Extend matching
set matchpairs+=<:>
" Always open vertical diffsplits. Ignore whitespace
set diffopt=filler,foldcolumn:0,iwhiteall,vertical,internal,algorithm:minimal
" When off the 'CTRL-D', 'CTRL-U', 'CTRL-B', 'CTRL-F', 'G', 'H', 'M', 'L',
" 'gg', 'd', '<<', '>>', <count>'%' the cursor is kept in the same column
" instead of moving it to the first non-blank of the line.
set nostartofline
" Try to not use temp files when redirecting shell commands output
set noshelltemp
" Scan current buffer, buffers from buffer list and tags for completion
set complete=.,b,t
" Persistent undo
set undofile
" Global search/replace by default. Consult help on how to subst for the first
" one only even with this option set
set gdefault
set wildmode=list:longest,full
" Case insensitive filename completion
set wildignorecase
" patterns to ignore when autocompleting for files
set wildignore+=*.pdf,*.mp3,*.avi,*.mpg,*.mp4,*.mkv,node_modules
set wildignore+=*.ogg,*.flv,*.png,*.jpg,*.svg,*.pyc,*.o,*.obj
set wildignore+=*.deb,*.ico,*.mov,*.swf,*.class,*.elc,*.native
set wildignore+=*.rbc,*.rbo,.svn,*.gem,._*,.DS_Store,*.dmg
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*
set wildignore+=.git,.localized
" These will get lower priority in filename autocompletion
set suffixes+=.bak,~,.swp,.bbl
set suffixes+=.info,.aux,.ind
set suffixes+=.blg,.brf,.cb
set suffixes+=.idx,.ilg,.inx
set suffixes+=.out,.toc,.dvi
set showtabline=0
set laststatus=2
" No awful vertical lines in splits
exec 'set fillchars+=vert:\ '
" Disable annoying cmdline message when in autocompletion
set shortmess+=c
" Minimum width of numbers column
set numberwidth=4
" Don't show hidden characters
set nolist
" Multibyte settings
set listchars=tab:»·,trail:.,eol:¬
" Enable auto-sourcing of per-project .nvimrc
set exrc
" Recommended to set whenever exrc is set
set secure
" True color support
set termguicolors
" Due to internal representation, Vim has problems with long lines in general.
" Highlights lines till column 500.
set synmaxcol=500
" Do not auto-wrap long lines
set formatoptions-=t
" Keep cursor on the bottom window when splitting horizontally. Easier for
" grepping, since the quicklist is right below
set splitbelow
" Position cursor to the right when splitting windows vertically.
set splitright
let &tabline='%!core#tabline()'
" Values obtained from evaluating %{} blocks don't get evaluated themselves.
" They are taken verbatim (including other %{} blocks). Ex:
" <
"   function Test()
"     return "%{'TEXT'}"
"   endfunction
"   set statusline=%{Test()}
" >
" Will end up in a statusline like %{'TEXT'}, instead of just 'TEXT'
"
" NOTE to future self: I spent 2 days learning about the statusline and hacking
" on it. It's disgusting. Before you forget how much time I spent here and
" undertake another status-line related despairing journey, consider that with
" enough time you'll probably come back to this simple implementation. It's way
" too hacky to customize the colors of the statusline. It's possible, but beware
" that it comes with despair and performance problems. I don't know about you,
" future self, but I like performance, and dislike despair.
let &statusline = ' %f '
let &statusline .= '%{core#statusline_flags()}'
let &statusline .= '%='
let &statusline .= '%{&ft} '
let &statusline .= '▏%{&ff} '
let &statusline .= '%{core#statusline_linter()}'
let &statusline .= '▏%l:%c %p%% '

" Commands {{{1

command! Vimrc vs $MYVIMRC
command! -nargs=+ Cabbrev call core#cabbrev(<f-args>)
command! -nargs=+ -complete=command Windo call core#windo(<q-args>)
command! -nargs=+ -complete=command Bufdo call core#bufdo(<q-args>)
command! -nargs=+ -complete=command Tabdo call core#tabdo(<q-args>)
command! -nargs=+ -complete=command Argdo call core#argdo(<q-args>)

Cabbrev vimr[c] Vimrc
Cabbrev man Man
Cabbrev w up
Cabbrev bufdo Bufdo
Cabbrev windo Windo
Cabbrev tabdo Tabdo
Cabbrev argdo Argdo

" Mappings {{{1

" Remember <C-U> as a new change
inoremap <C-U> <C-G>u<C-U>
inoremap jk <ESC>
tnoremap jk <C-\><C-N>
nnoremap , :
vnoremap , :
" Covered by sneak
" nnoremap : ,
" vnoremap : ,
" By default, <c-n> and <c-p> recall older or more recent command-lines from
" history. But <up> and <down> are even smarter! They recall the command-line
" whose beginning matches the current command-line
cnoremap <C-N> <DOWN>
cnoremap <C-P> <UP>
" CTRL-C doesn't trigger the InsertLeave autocmd
inoremap <C-C> <ESC>
" Visually select previously pasted text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
" Easier moving between tabs
nnoremap <silent> <C-H> :tabprevious<CR>
nnoremap <silent> <C-L> :tabnext<CR>
" Make 'v' deselect visual mode
vnoremap v <ESC>
" Make-believe that visually-wrapped lines are hard-wrapped
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
" This should be built-in
nnoremap Y y$
" Expand %% to directory of current file in command-line mode
cnoremap %% <C-R>=fnameescape(expand("%:~:h"))<CR>
" Toggle syntax
nnoremap <expr> <silent> yoy '<cmd>set syntax=' . (&syntax == 'ON' ? 'OFF' : 'ON') . '<cr>'
" Toggle tabline
nnoremap <expr> <silent> yot '<cmd>set showtabline=' . (&showtabline != 2 ? 2 : 0) . '<cr>'
" Toggle Quickfix/LocList
nnoremap <expr> <silent> <leader>q (get(getqflist({'winid': 1}), 'winid') != 0? ':cclose' : ':botright copen') . '<cr>:wincmd p<cr>'
nnoremap <expr> <silent> <leader>w (get(getloclist(0, {'winid': 1}), 'winid') != 0? ':lclose' : ':lopen') . '<CR>:wincmd p<cr>'
" Make * and # work on visual mode too
xnoremap * :call core#vsetsearch('/')<cr>/<c-r>=@/<cr><cr>
xnoremap # :call core#vsetsearch('?')<cr>?<c-r>=@/<cr><cr>
" https://vi.stackexchange.com/questions/2365/how-can-i-get-n-to-go-forward-even-if-i-started-searching-with-or
nnoremap <expr> n (v:searchforward ? 'n' : 'N')
nnoremap <expr> N (v:searchforward ? 'N' : 'n')

" Autocommands {{{1

augroup init.vim " {{{2
    au!
    " https://github.com/neovim/neovim/issues/1936
    au FocusGained * :checktime
    au FileType * set syntax=ON
    " au FilterWritePre * if &diff | set syntax=OFF | endif
    au VimLeavePre * call core#tabdo('cclose')
    au VimLeavePre * call core#tabdo('lclose')
    au CmdwinEnter * map <silent> <buffer> <c-g> <c-c><c-c>
    " au BufRead * let b:tracked = 0 | call jobstart(
    " \ 'git ls-files --error-unmatch '.shellescape(expand('%:p')),
    " \ {'on_exit': function({ bnum, jobid, code, type -> setbufvar(bnum, 'tracked', !code) }, [bufnr('%')])})
augroup END

" Plugins {{{1

" In general:
" - Variables and <plug> mappings can be defined before the plugin loads
" - Other stuff should go after it loads

let g:loaded_2html_plugin = 1
let g:loaded_gzip = 1
let g:loaded_matchparen = 1
let g:loaded_netrwPlugin = 1
let g:loaded_tarPlugin = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_zipPlugin = 1

call plug#begin('~/.local/share/nvim/plugged') " {{{2
" Motions {{{2

Plug 'https://github.com/justinmk/vim-ipmotion' " {{{3
let g:ip_skipfold = 1

Plug 'https://github.com/vim-utils/vim-vertical-move' " {{{3

Plug 'https://github.com/tpope/vim-rsi' " {{{3
let g:rsi_no_meta = 1

Plug 'https://github.com/justinmk/vim-sneak' " {{{3
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1
let g:sneak#label_esc = "\<Space>"
map : <Plug>Sneak_,
hi! link SneakScope TermCursor

" Text objects {{{2

Plug 'https://github.com/tpope/vim-surround' " {{{3
let g:surround_indent = 0

Plug 'https://github.com/kana/vim-textobj-user' " {{{3

Plug 'https://github.com/kana/vim-textobj-line' " {{{3
let g:textobj_line_no_default_key_mappings = 1
xmap ae <plug>(textobj-line-a)
omap ae <plug>(textobj-line-a)
xmap ie <plug>(textobj-line-i)
omap ie <plug>(textobj-line-i)

Plug 'https://github.com/glts/vim-textobj-comment' " {{{3

Plug 'https://github.com/Julian/vim-textobj-variable-segment' " {{{3

Plug 'https://github.com/kana/vim-textobj-indent' " {{{3

Plug 'https://github.com/wellle/targets.vim' " {{{3
" let g:targets_argTrigger = 'a'
" let g:targets_tagTrigger = 't'
" let g:targets_aiAI = 'ai  '
" let g:targets_pairs = '() {} [] <>'
" let g:targets_quotes = '" '' `'
" let g:targets_separators = ', . ; : + - = ~ _ *" / | \ & $ ! @ % ^ ?'

" Operators {{{2

Plug 'https://github.com/kana/vim-operator-user' " {{{3

Plug 'https://github.com/tommcdo/vim-exchange' " {{{3
let g:exchange_no_mappings = 1
map gx <plug>(Exchange)
nmap gxc <plug>(ExchangeClear)
nmap gxx <plug>(ExchangeLine)

Plug 'https://github.com/tommcdo/vim-lion' " {{{3

Plug 'https://github.com/tpope/vim-commentary' " {{{3
let g:commentary_map_backslash = 0
map gc <plug>Commentary
nmap gcc <plug>CommentaryLine

Plug 'https://github.com/tpope/vim-repeat' " {{{3

" Completion / Language Tools {{{2

Plug 'https://github.com/ajh17/VimCompletesMe' " {{{3

" Editing {{{2

Plug 'https://github.com/tpope/vim-abolish' " {{{3

Plug 'https://github.com/arthurxavierx/vim-caser' " {{{3
let g:caser_prefix = '<leader>r'

" Folding {{{2

Plug 'https://github.com/Konfekt/FastFold' " {{{3

" Filetypes {{{2

Plug 'https://github.com/sheerun/vim-polyglot' " {{{3


" VCS {{{2

Plug 'https://github.com/tpope/vim-fugitive' " {{{3
Cabbrev git Git
Cabbrev gbl Gblame -w -M
Cabbrev gbr Gbrowse
Cabbrev gd Gdiff
Cabbrev ge Gedit
Cabbrev gf Gfetch
Cabbrev gl Glog
Cabbrev gll Gllog
Cabbrev gcm Gcommit
Cabbrev gcma Gcommit --amend
Cabbrev gcmaa Gcommit --amend --reuse-message HEAD
Cabbrev gr Gread
Cabbrev gs Gstatus
Cabbrev gw Gwrite
Cabbrev gpu Gpush
Cabbrev gpuf Gpush --force
Cabbrev gco Git checkout
autocmd BufReadPost fugitive:// setlocal bufhidden=delete

Plug 'https://github.com/tpope/vim-rhubarb' " {{{3

Plug 'https://github.com/whiteinge/diffconflicts' " {{{3

" Integrations {{{2

Plug 'https://github.com/w0rp/ale' " {{{3
hi! link ALEError Error
hi! link ALEWarning WarningMsg
hi! link ALEVirtualTextError Error

let g:airline#extensions#ale#enabled = 0
let g:ale_enabled = 1
let g:ale_set_loclist = 1
let g:ale_set_quickfix = 0
let g:ale_cache_executable_check_failures = 1
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_insert_leave = 0
let g:ale_warn_about_trailing_whitespace = 1

let g:ale_set_highlights = 1

let g:ale_echo_cursor = 1
let g:ale_echo_msg_format = '[%severity%:%linter%] %s'
let g:ale_echo_msg_error_str = 'error'
let g:ale_echo_msg_info_str = 'info'
let g:ale_echo_msg_warning_str = 'warn'

let g:ale_set_signs = 0
" let g:ale_sign_error = '»'
" let g:ale_sign_warning = '»'
" let g:ale_sign_info = '»'

" Fixers
let s:fixers = ['remove_trailing_lines', 'trim_whitespace']
let g:ale_fixers = {
\ 'python': ['isort', 'yapf'] + s:fixers,
\ 'typescript': ['tslint', 'prettier'] + s:fixers,
\ 'typescript.jsx': ['tslint', 'prettier'] + s:fixers,
\ 'javascript': ['prettier_eslint', 'prettier'] + s:fixers,
\ 'javascript.jsx': ['prettier_eslint', 'prettier'] + s:fixers,
\ 'json': ['prettier'] + s:fixers
\ }

" Python
let g:ale_python_auto_pipenv = 1
let g:ale_python_pylint_change_directory = 0
let g:ale_python_mypy_ignore_invalid_syntax = 1
let g:ale_python_mypy_options = '--ignore-missing-imports --follow-imports=skip'

nmap <leader>ta <plug>(ale_toggle_buffer)
nmap <leader>af <plug>(ale_fix)
nmap <leader>al <plug>(ale_lint)
nmap <leader>ar <plug>(ale_reset)
nmap <leader>ab <plug>(ale_reset_buffer)
nnoremap <leader>ai :ALEInfo<CR>
nnoremap <leader>ad :ALEDetail<CR>
nnoremap <leader>as :ALEFixSuggest<CR>
nmap <silent> [r <plug>(ale_previous)
nmap <silent> ]r <plug>(ale_next)
nmap <silent> [R <plug>(ale_first)
nmap <silent> ]R <plug>(ale_last)
autocmd User ALELintPre  hi User3 guibg=#cb4b16 | redrawstatus
autocmd User ALELintPost hi User3 guibg=#839496 | redrawstatus

" Plug 'https://github.com/neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'} " {{{3
" " This is actually an operator
" vmap <silent> = <plug>(coc-format-selected)
" nmap <silent> = <plug>(coc-format-selected)
" nmap <silent> == <plug>(coc-format)
" nmap <leader>d1 <plug>(coc-definition)
" nmap <leader>d2 <plug>(coc-declaration)
" nmap <leader>d3 <plug>(coc-implementation)
" nmap <leader>d4 <plug>(coc-type-definition)
" nmap <leader>li <plug>(coc-diagnostic-info)
" nmap <leader>lr <plug>(coc-rename)
" nmap <leader>la <plug>(coc-references)
" nnoremap <leader>lh <cmd>call CocAction('doHover')<cr>
" nnoremap [r <plug>(coc-diagnostic-prev)
" nnoremap ]r <plug>(coc-diagnostic-next)
" function! s:coc()
"     hi! link CocErrorHighlight ErrorMsg
"     hi! link CocWarningHighlight WarningMsg
"     exe 'hi CocInfoHighlight guifg=yellow'
"     exe 'hi CocHintHighlight guifg=blue'
" endfunction
" au VimEnter * call s:coc()

Plug 'https://github.com/junegunn/fzf' | Plug '~/Code/mine/fzf.vim', { 'branch': 'local-gfiles' } " {{{3
function! s:fzf_statusline()
    setlocal statusline=%#fzf1#\ FZF▕
    if !empty(get(b:fzf, 'name'))
        setlocal statusline+=\ %{b:fzf.name}▕%#fzf2#
    endif
endfunction

let g:fzf_layout = {'down': '~30%'}
nnoremap <silent> <space>, <cmd>History:<cr>
nnoremap <silent> <space>/ <cmd>History/<cr>
nnoremap <silent> <space>c <cmd>Commands!<cr>
nnoremap <silent> <space>h <cmd>Helptags!<cr>
nnoremap <silent> <space>i <cmd>History<cr>
nnoremap <silent> <space>l <cmd>BLines!<cr>
nnoremap <silent> <space>w <cmd>Windows<cr>
nnoremap <silent> <space>b <cmd>Buffers<cr>
nnoremap <silent> <space>f <cmd>exec 'Files ' . fnamemodify(expand('%'), ':~:h')<cr>
nnoremap <silent> <space>g <cmd>GLFiles<cr>
hi! link fzf1 StatusLine
hi! link fzf2 StatusLineNC
autocmd! User FzfStatusLine call <SID>fzf_statusline()
Cabbrev rg Rg

Plug 'https://github.com/tyru/open-browser.vim' " {{{3
let g:openbrowser_message_verbosity = 1
let g:openbrowser_use_vimproc = 0
map go <plug>(openbrowser-smart-search)

Plug 'https://github.com/tpope/vim-eunuch' " {{{3
Cabbrev cmo Chmod
Cabbrev mk Mkdir
Cabbrev ue SudoEdit
Cabbrev uw SudoWrite
" Custom function to Git move/remove/rename if there's a git repo.
" Otherwise use eunuch's functions
function! s:cmd(cmd1, cmd2, bang, arg)
    try
        exec a:cmd1 . a:bang . ' ' . a:arg
    catch /.*/
        exec a:cmd2 . a:bang . ' ' . a:arg
    endtry
endfunction
command! -bang -nargs=1 -complete=file Mv call <SID>cmd("Gmove", "Move", "<bang>", <f-args>)
command! -bang -nargs=1 -complete=file Ren call <SID>cmd("Grename", "Rename", "<bang>", <f-args>)
command! -bang Rm call <SID>cmd("Gdelete", "Delete", "<bang>", "")
Cabbrev mv Mv
Cabbrev rm Rm
Cabbrev ren Ren

Plug 'https://github.com/mhinz/vim-grepper' " {{{3
function! s:grepper()
    if exists('g:grepper')
        let g:grepper.switch = 0
        let g:grepper.dir = 'repo,file,pwd'
        let g:grepper.side_cmd = 'tabnew'
        let g:grepper.highlight = 1
        let g:grepper.tools = ['rg', 'rgall']
        let g:grepper.operator.prompt = 1
        let g:grepper.rg = { 'grepprg': &grepprg }
        let g:grepper.rgall = { 'grepprg' : &grepprg . '--no-ignore-vcs' }
    endif
endfunction
au VimEnter * call s:grepper()
map gs <Plug>(GrepperOperator)
nnoremap <silent><expr> gss ':Grepper ' . (&ft ==# 'dirvish' ? '-dir file' : '') . '<cr>'
nnoremap <silent><expr> gsl ':Grepper -noquickfix ' . (&ft ==# 'dirvish' ? '-dir file' : '') . '<cr>'

Plug 'https://github.com/editorconfig/editorconfig-vim' " {{{3

" Colors {{{2

Plug 'https://github.com/smallwat3r/vim-mono-sw' " {{{3
Plug 'https://github.com/zaki/zazen' " {{{3
Plug 'https://github.com/ryanpcmcquen/true-monochrome_vim' " {{{3
Plug 'https://github.com/andreasvc/vim-256noir' " {{{3
Plug 'https://github.com/norcalli/nvim-colorizer.lua' " {{{3
" Plug 'https://github.com/chrisbra/Colorizer' " {{{3
" nmap <leader>tc <cmd>ColorToggle<CR>
let g:colorizer_colornames = 0
let g:colorizer_disable_bufleave = 1
Plug 'https://github.com/junegunn/seoul256.vim' " {{{3
Plug 'https://github.com/rakr/vim-one' " {{{3
Plug 'https://github.com/reedes/vim-colors-pencil' " {{{3
Plug 'https://github.com/rafi/awesome-vim-colorschemes' " {{{3
let ayucolor = 'light'
Plug 'https://github.com/xolox/vim-misc' " {{{3
Plug 'https://github.com/xolox/vim-colorscheme-switcher' " {{{3
let g:colorscheme_switcher_keep_background = 1

" Other {{{2

Plug 'https://github.com/mhinz/vim-startify' " {{{3
let g:startify_change_to_vcs_root = 1
let g:startify_fortune_use_unicode = 1
let g:startify_change_to_dir = 0
let g:startify_lists = [
\ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
\ ]
let g:startify_bookmarks = [
\ '~/Notes/random.md',
\ '~/Notes/todo.md',
\ '~/Resources/smartprocure/bid-search',
\ '~/Resources/smartprocure/contexture-react',
\ '~/Resources/smartprocure/contexture-client',
\ '~/Resources/smartprocure/contexture',
\ '~/Resources/smartprocure',
\ '~/Code/mine/furnisher/user/home-manager',
\ '~/Code/home-manager/modules',
\ '~/Code/mine/trello-clone',
\ ]
autocmd User Startified setlocal buftype=nofile
nnoremap <space>s <cmd>Startify<cr>

Plug 'https://github.com/tpope/vim-characterize' " {{{3
nmap gz <plug>(characterize)

Plug 'https://github.com/tpope/vim-unimpaired' " {{{3
for m in [ '[l', '[L', ']l', ']L', '=p', '=P', '=o', '=O', '=op']
    exec 'silent! unmap '.m
endfor
nmap [w <plug>unimpairedLPrevious
nmap [W <plug>unimpairedLFirst
nmap ]w <plug>unimpairedLNext
nmap ]W <plug>unimpairedLLast
nmap co yo

Plug 'https://github.com/tpope/vim-scriptease' " {{{3
Cabbrev ve Vedit
Cabbrev vo Vopen
Cabbrev vr Vread
Cabbrev vs Vsplit
Cabbrev vv Vvsplit
Cabbrev vt Vtabedit
Cabbrev vos Vsplit!
Cabbrev vov Vvsplit!
Cabbrev vot Vtabedit!

Plug 'https://github.com/majutsushi/tagbar' " {{{3
function! s:filetype_tagbar()
    set signcolumn=no
    syntax match TagbarFunc  '\s\+\zs\w*\ze('
    hi! link TagbarFunc Function
    hi! link TagbarSignature Normal
endfunction
au FileType tagbar call s:filetype_tagbar()
let g:tagbar_sort = 0
let g:tagbar_autofocus = 1
let g:tagbar_show_visibility = 0
let g:tagbar_show_linenumbers = 0
let g:tagbar_left = 1
let g:tagbar_zoomwidth = 0
let g:tagbar_iconchars = ['▸', '▾']
let g:tagbar_type_typescript = {
\ 'ctagsbin' : 'tstags',
\ 'ctagsargs' : '-f-',
\ 'kinds': [
    \ 'e:enums:0:1',
    \ 'f:function:0:1',
    \ 't:typealias:0:1',
    \ 'M:Module:0:1',
    \ 'I:import:0:1',
    \ 'i:interface:0:1',
    \ 'C:class:0:1',
    \ 'm:method:0:1',
    \ 'p:property:0:1',
    \ 'v:variable:0:1',
    \ 'c:const:0:1',
\ ],
\ 'sort' : 0
\ }
nnoremap <silent> <leader>tt :TagbarToggle<CR>

Plug 'https://github.com/mbbill/undotree' " {{{3
let g:undotree_DiffAutoOpen = 0
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_SplitWidth = 40
nnoremap <silent> <leader>tu :UndotreeToggle<CR>

Plug 'https://github.com/AndrewRadev/linediff.vim' " {{{3
xnoremap <silent> <leader>d :Linediff<CR>

Plug 'https://github.com/justinmk/vim-dirvish' " {{{3
function! s:filetype_dirvish()
    " Directories first
    sort ,^.*[\/],
    nmap <buffer> q gq
endfunction
autocmd! FileType dirvish call s:filetype_dirvish()
" Buffer's directory
nmap <bs> <plug>(dirvish_up)
" Vim's cwd
nnoremap <silent> <space><bs> <cmd>Dirvish<cr>
" Buffer's repo
nnoremap <silent> g<bs> <cmd>exe 'Dirvish ' . fnamemodify(b:git_dir, ':h')<cr>
let g:dirvish_mode = 2

Plug 'https://github.com/kopischke/vim-fetch' " {{{3

Plug 'https://github.com/zhimsel/vim-stay' " {{{3
set viewoptions=cursor,folds,slash,unix

Plug 'https://github.com/szw/vim-maximizer' " {{{3
nnoremap <silent> <C-W>m :MaximizerToggle!<CR>
vnoremap <silent> <C-W>m :MaximizerToggle!<CR>gv
nnoremap <silent> <C-W><C-M> :MaximizerToggle!<CR>
vnoremap <silent> <C-W><C-M> :MaximizerToggle!<CR>gv
let g:maximizer_set_default_mapping = 0

Plug 'https://github.com/tweekmonster/startuptime.vim' " {{{3

call plug#end() " {{{2

" Rest {{{1

syntax manual
" :h syn-sync-third
syntax sync minlines=50
set background=light
silent! colorscheme home-manager

" vim: fdm=marker
