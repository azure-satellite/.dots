-- Highly recommended to run :options

vim.o.viewoptions = "cursor,folds,slash,unix"

-- Used for the CursorHold autocommand
vim.o.updatetime = 300

-- Enable mouse for all modes
vim.o.mouse = "a"

vim.o.completeopt = "menu"

vim.o.cpoptions = "aABceFs_q"

vim.o.inccommand = "nosplit"

vim.o.smartcase = true

vim.o.ignorecase = true

vim.o.wrapscan = false

-- Do not insert two spaces after J
vim.o.joinspaces = false

-- Not a vim option, but this allows us to use this value for other things
vim.g.grepprg = {
  "rg",
  "--color=never",
  "--no-heading",
  "--with-filename",
  "--line-number",
  "--column",
  "--smart-case",
  "--hidden",
  "--glob",
  "'!package-lock.json'",
  "--glob",
  "'!.git'"
}
vim.o.grepprg = table.concat(vim.g.grepprg, " ")

vim.o.grepformat = "%f:%l:%c:%m,%f:%l:%m"

vim.o.showbreak = "↪  "

-- Round indent to multiple of shiftwidth
vim.o.shiftround = true

-- Do not complain when leaving buffers with changes
vim.o.hidden = true

-- Always open vertical diffsplits. Ignore whitespace
vim.o.diffopt =
  "filler,foldcolumn:0,iwhiteall,vertical,internal,algorithm:minimal"

-- Try to keep cursor in the same column when moving vertically
vim.o.startofline = false

-- Try to not use temp files when redirecting shell commands output
vim.o.shelltemp = false

-- Global search/replace by default. Can be unset on a per-search basis
vim.o.gdefault = true

vim.o.wildmode = "longest:full,full"

vim.o.wildignorecase = true

vim.o.wildignore =
  "*.pdf,*.mp3,*.avi,*.mpg,*.mp4,*.mkv,*.ogg,*.flv,*.png,*.jpg,*.pyc,*.o,*.obj,*.deb,*.ico,*.mov,*.swf,*.class,*.elc,*.native,*.rbc,*.rbo,.svn,*.gem,._*,.DS_Store,*.dmg,.git/,.localized"

-- These will get lower priority in filename autocompletion
vim.o.suffixes =
  ".bak,~,.o,.h,.info,.swp,.obj,.bak,~,.swp,.bbl,.info,.aux,.ind,.blg,.brf,.cb,.idx,.ilg,.inx,.out,.toc,.dvi"

vim.o.showtabline = 2

vim.o.laststatus = 2

vim.o.shortmess = "filnxtToOFc"

vim.o.fillchars = "vert: "

vim.o.listchars = "tab:»·,trail:.,eol:¬"

-- True color support
vim.o.termguicolors = true

-- Keep cursor on the bottom window when splitting horizontally. Easier for grepping, since the quicklist is right below
vim.o.splitbelow = true

-- Position cursor to the right when splitting windows vertically.
vim.o.splitright = true

vim.o.tabline = "%!core#tabline()"

-- TODO: Look into https://gist.github.com/tasmo/bb79473aedb6797f016522109884ad9a
-- Values obtained from evaluating %{} blocks don't get evaluated themselves.
-- They are taken verbatim (including other %{} blocks). Ex:
-- <
--   function Test()
--     return "%{'TEXT'}"
--   endfunction
--   set statusline=%{Test()}
-- >
-- Will end up in a statusline like %{'TEXT'}, instead of just 'TEXT'
--
-- NOTE to future self: I spent 2 days learning about the statusline and hacking
-- on it. It's disgusting. Before you forget how much time I spent here and
-- undertake another status-line related despairing journey, consider that with
-- enough time you'll probably come back to this simple implementation. It's way
-- too hacky to customize the colors of the statusline. It's possible, but beware
-- that it comes with despair and performance problems. I don't know about you,
-- future self, but I like performance, and dislike despair.
vim.o.statusline =
  "%{core#statusline_file()} %{core#statusline_flags()} %=%{&ft} ▏%l:%c %p%%"
-- "%{core#statusline_file()} %{core#statusline_flags()} %= %{core#statusline_lsp()}▏%{&ft} ▏%l:%c %p%%"

-- Buffer/window/tab local options don't work with vim.o as with :set. See
-- https://github.com/neovim/neovim/issues/12978 for more details

-- vim.cmd does not support comments!

-- Buffer local options

vim.cmd [[
set tabstop=2
set shiftwidth=2
set softtabstop=2
set noswapfile
set textwidth=80
set expandtab
set matchpairs=(:),{:},[:],<:>
set formatoptions=jcroql
set complete=.,b,t
set undofile
]]

-- Window local options

vim.cmd [[
set signcolumn=yes
set foldmethod=indent
set foldlevel=99
set foldminlines=0
set linebreak
set breakindent
]]
