-- Highly recommended to run :options

-- Global options

-- Used for the CursorHold autocommand
vim.o.updatetime = 300

-- Enable mouse for all modes
vim.o.mouse = "a"

vim.o.cpoptions = "aABceFs_q"

vim.o.inccommand = "nosplit"

vim.o.smartcase = true

vim.o.ignorecase = true

-- Searches do not wrap around the end of the file
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

-- Format to recognize for the ":grep" command output
vim.o.grepformat = "%f:%l:%c:%m,%f:%l:%m"

-- String to put at the start of lines that have been wrapped
vim.o.showbreak = "↪  "

-- Round indent to multiple of shiftwidth
vim.o.shiftround = true

-- Do not complain when leaving buffers with changes
vim.o.hidden = true

-- Always open vertical diffsplits. Ignore whitespace
vim.o.diffopt = "filler,foldcolumn:0,iwhiteall,vertical,internal,algorithm:minimal"

-- Try to keep cursor in the same column when moving vertically
vim.o.startofline = false

-- Try to not use temp files when redirecting shell commands output
vim.o.shelltemp = false

-- Global search/replace by default. Can be unset on a per-search basis
vim.o.gdefault = true

-- Ignore case when completing file name and directories
vim.o.wildignorecase = true

-- Patterns to ignore when completing file or directory names
-- Also influences the result of expand(), glob(), and globpath()
vim.o.wildignore =
  "*.pdf,*.mp3,*.avi,*.mpg,*.mp4,*.mkv,*.ogg,*.flv,*.png,*.jpg,*.pyc,*.o,*.obj,*.deb,*.ico,*.mov,*.swf,*.class,*.elc,*.native,*.rbc,*.rbo,.svn,*.gem,._*,.DS_Store,*.dmg,.git/,.localized"

-- Files with these suffixes will get lower priority in filename autocompletion
vim.o.suffixes =
  ".bak,~,.o,.h,.info,.swp,.obj,.bak,~,.swp,.bbl,.info,.aux,.ind,.blg,.brf,.cb,.idx,.ilg,.inx,.out,.toc,.dvi"

vim.o.shortmess = "filnxtToOFc"

-- Characters to draw for
-- * Vertical split separators
-- * Deleted lines in diffs
vim.o.fillchars = "vert: ,diff: "

-- Characters to draw for
-- * Tabs
-- * Trailing whitespace
-- * EOL indicators
vim.o.listchars = "tab:»·,trail:.,eol:¬"

-- True color support
vim.o.termguicolors = true

-- Keep cursor on the bottom window when splitting horizontally. Easier for grepping, since the quicklist is right below
vim.o.splitbelow = true

-- Position cursor to the right when splitting windows vertically.
vim.o.splitright = true

-- Buffer local options

vim.o.tabstop = 2

vim.o.shiftwidth = 2

vim.o.softtabstop = 2

vim.o.swapfile = false

vim.o.textwidth = 80

vim.o.expandtab = true

vim.o.matchpairs = "(:),{:},[:],<:>"

vim.o.formatoptions = "jcroql"

vim.o.complete = ".,b,t"

vim.o.undofile = true

-- -- Window local options

vim.o.signcolumn = "yes"

vim.o.foldmethod = "indent"

vim.o.foldlevel = 99

vim.o.foldminlines = 0

vim.o.linebreak = true

vim.o.breakindent = true
