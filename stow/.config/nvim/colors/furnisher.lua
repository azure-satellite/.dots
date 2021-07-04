-- Prevent vim from defining its own highlights
-- See $VIMRUNTIME/syntax/syncolor.vim
vim.g.colors_name = "furnisher"

local c = require("theme")
local f = require("func")

vim.g.terminal_color_0 = c.white
vim.g.terminal_color_1 = c.red
vim.g.terminal_color_2 = c.green
vim.g.terminal_color_3 = c.yellow
vim.g.terminal_color_4 = c.blue
vim.g.terminal_color_5 = c.magenta
vim.g.terminal_color_6 = c.cyan
vim.g.terminal_color_7 = c.black
vim.g.terminal_color_8 = c.neutral0
vim.g.terminal_color_9 = c.neutral1
vim.g.terminal_color_10 = c.neutral2
vim.g.terminal_color_11 = c.neutral3
vim.g.terminal_color_12 = c.neutral4
vim.g.terminal_color_13 = c.neutral5
vim.g.terminal_color_14 = c.neutral6
vim.g.terminal_color_15 = c.neutral7

local orange = "#e36209"

-- :h highlight-groups
local builtin_groups = {
  -- Cursor
  {g = "Cursor", fg = c.cursor.fg, bg = c.cursor.bg},
  {g = "CursorColumn", bg = c.neutral1},
  {g = "CursorLine", bg = c.neutral2, style = "bold"},
  {g = "CursorLineNr", fg = c.neutral5, bg = c.neutral1},
  {g = "TermCursor", fg = c.cursor.fg, bg = c.cursor.bg},
  {g = "TermCursorNC", fg = c.cursor.fg, bg = c.cursor.bg},
  -- Statusline
  {g = "StatusLine", fg = c.neutral0, bg = c.neutral6, style = "bold"},
  {g = "StatusLineNC", fg = c.neutral6, bg = c.neutral3, style = "bold"},
  -- Tabline
  {g = "TabLine", fg = c.neutral6, bg = c.neutral3, style = "bold"},
  {g = "TabLineFill", fg = c.neutral6, bg = c.neutral3, style = "bold"},
  {g = "TabLineSel", fg = c.neutral0, bg = c.neutral6, style = "bold"},
  -- Diff
  {g = "DiffAdd", bg = c.diffAdded.bg},
  {g = "DiffDelete", bg = c.diffRemoved.bg, fg = c.diffRemoved.fg},
  {g = "DiffText", bg = c.diffChanged.bg},
  -- Popup menu
  {g = "Pmenu", fg = c.neutral6, bg = c.neutral2},
  {g = "PmenuSel", fg = c.neutral0, bg = c.neutral6},
  {g = "PmenuSbar", bg = c.neutral2},
  {g = "PmenuThumb", bg = c.blue},
  -- Search
  {g = "Search", bg = "#fffc4a"},
  {g = "IncSearch", bg = "#ff9d14"},
  -- Spelling
  {g = "SpellBad", fg = c.neutral7, bg = c.red},
  {g = "SpellCap", fg = c.neutral7, bg = c.blue},
  {g = "SpellLocal", fg = c.yellow},
  {g = "SpellRare", fg = c.neutral7, bg = "#4e5166"},
  -- Other
  {g = "ColorColumn", bg = c.neutral1},
  {g = "FoldColumn", fg = c.blue},
  {g = "Folded", fg = c.neutral5, bg = "#f1f8ff"},
  {g = "VertSplit", fg = c.neutral6, bg = c.neutral3, style = "bold"},
  {g = "Visual", bg = "#b5daff"},
  {g = "WarningMsg", fg = orange, style = "bold"},
  {g = "Whitespace", fg = c.blue},
  {g = "WildMenu", fg = c.neutral7, bg = c.cyan},
  {g = "LineNr", fg = c.neutral0, bg = c.neutral6},
  {g = "Conceal", fg = c.cyan},
  {g = "EndOfBuffer", fg = c.blue},
  {g = "ErrorMsg", fg = c.red, style = "bold"},
  {g = "Directory", fg = c.green},
  {g = "MatchParen", fg = c.neutral6, bg = orange},
  {g = "ModeMsg", fg = c.yellow},
  {g = "MoreMsg", fg = c.yellow},
  {g = "NonText", fg = c.blue},
  {g = "Normal", fg = c.text.fg},
  {g = "Question", fg = c.yellow},
  {g = "QuickFixLine", c.neutral2, style = "bold"},
  {g = "SignColumn"},
  {g = "SpecialKey", fg = c.neutral3},
  {g = "Substitute", bg = "#fffc4a"},
  {g = "Title", fg = orange}
}

-- :h nvim-treesitter-highlights
local ts_groups = {
  -- Constants
  {g = "TSBoolean", fg = c.constant.fg},
  {g = "TSConstBuiltin", fg = c.constant.fg},
  {g = "TSConstant", fg = c.constant.fg},
  {g = "TSFloat", fg = c.constant.fg},
  {g = "TSNumber", fg = c.constant.fg},
  -- Comment
  {g = "TSComment", fg = c.muted.fg},
  -- Keywords
  {g = "TSConditional", fg = c.keyword.fg},
  {g = "TSRepeat", fg = c.keyword.fg},
  {g = "TSKeyword", fg = c.keyword.fg},
  {g = "TSKeywordFunction", fg = c.keyword.fg},
  {g = "TSKeywordOperator", fg = c.keyword.fg},
  {g = "TSException", fg = c.keyword.fg},
  {g = "TSInclude", fg = c.keyword.fg},
  -- Other
  {g = "TSConstructor", fg = orange},
  {g = "TSDanger", fg = c.muted.fg},
  {g = "TSField", fg = c.green},
  {g = "TSFunction", fg = c.magenta},
  {g = "TSLabel", fg = c.text.fg},
  {g = "TSMethod", fg = c.magenta},
  {g = "TSNamespace", fg = c.text.fg},
  {g = "TSOperator", fg = c.blue},
  {g = "TSParameter", fg = c.text.fg},
  {g = "TSProperty", fg = c.blue},
  {g = "TSPunctBracket", fg = c.text.fg},
  {g = "TSPunctDelimiter", fg = c.text.fg},
  {g = "TSPunctSpecial", fg = c.text.fg},
  {g = "TSString", fg = c.string.fg},
  {g = "TSStringEscape", fg = c.string.fg},
  {g = "TSSymbol", fg = c.string.fg},
  {g = "TSTag", fg = c.green},
  {g = "TSTagDelimiter", fg = c.blue},
  {g = "TSType", fg = c.text.fg},
  {g = "TSTypeBuiltin", fg = c.text.fg},
  {g = "TSVariable", fg = c.text.fg},
  {g = "TSVariableBuiltin", fg = c.text.fg}
}

-- Build clear command
local function clear(group)
  return string.format("hi clear %s", string.match(group, "^%g+"))
end

-- Build highlight command
local function highlight(def)
  return string.format(
    "hi! %s guifg=%s guibg=%s gui=%s",
    def.g,
    def.fg or "none",
    def.bg or "none",
    def.style or "none"
  )
end

-- -- Clear all highlight groups
-- local existing = vim.fn.split(vim.api.nvim_exec("hi", true), "\n")
-- vim.cmd(table.concat(f.map(clear, existing), " | "))

-- Define UI syntax groups
vim.cmd(table.concat(f.map(highlight, builtin_groups), " | "))

-- Define TreeSitter syntax groups
vim.cmd(table.concat(f.map(highlight, ts_groups), " | "))
