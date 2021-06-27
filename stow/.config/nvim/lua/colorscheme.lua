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

-- :h highlight-groups
local builtin_groups = {
  -- Cursor
  {g = "Cursor", fg = c.cursor.fg, bg = c.cursor.bg},
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
  {g = "DiffAdd", fg = "#859900", style = "bold"},
  {g = "DiffChange"},
  {g = "DiffDelete", fg = "#dc322f", style = "bold"},
  {g = "DiffText", fg = "#268bd2", style = "bold"},
  -- Popup menu
  {g = "Pmenu", fg = c.neutral6, bg = c.neutral2},
  {g = "PmenuSel", fg = c.neutral0, bg = c.neutral6},
  {g = "PmenuSbar", bg = c.neutral2},
  {g = "PmenuThumb", bg = c.blue},
  -- Other
  {g = "CursorColumn", bg = c.neutral1},
  {g = "CursorLine", bg = c.neutral2, style = "bold"},
  {g = "CursorLineNr", fg = c.neutral5, bg = c.neutral1},
  {g = "ColorColumn", bg = c.neutral1},
  {g = "FoldColumn", fg = c.blue},
  {g = "Folded", fg = c.blue},
  {g = "VertSplit", fg = c.neutral6, bg = c.neutral3, style = "bold"},
  {g = "Visual", bg = c.neutral3},
  {g = "WarningMsg", fg = c.orange, style = "bold"},
  {g = "Whitespace", fg = c.blue},
  {g = "WildMenu", fg = c.neutral7, bg = c.cyan},
  {g = "LineNr", fg = c.blue},
  {g = "Conceal", fg = c.cyan},
  {g = "EndOfBuffer", fg = c.blue},
  {g = "ErrorMsg", fg = c.red, style = "bold"},
  {g = "Directory", fg = c.green},
  {g = "IncSearch", fg = c.yellow, c.neutral3, style = "bold"},
  {g = "MatchParen", fg = c.neutral6, bg = c.orange},
  {g = "ModeMsg", fg = c.yellow},
  {g = "MoreMsg", fg = c.yellow},
  {g = "NonText", fg = c.blue},
  {g = "Normal", fg = c.neutral6},
  {g = "Question", fg = c.yellow},
  {g = "QuickFixLine", c.neutral2, style = "bold"},
  {g = "Search", fg = c.yellow, bg = c.neutral3, style = "bold"},
  {g = "SignColumn", fg = c.blue},
  {g = "SpecialKey", fg = c.neutral3},
  {g = "SpellBad", fg = c.neutral7, bg = c.red},
  {g = "SpellCap", fg = c.neutral7, bg = c.blue},
  {g = "SpellLocal", fg = c.yellow},
  {g = "SpellRare", fg = c.neutral7, bg = "#4e5166"},
  {g = "Substitute", fg = c.yellow, bg = c.neutral3, style = "bold"},
  {g = "Title", fg = c.orange}
}

-- :h group-name
local syntax_groups = {
  -- Comment
  {g = "Comment", fg = c.neutral4},
  -- Constants
  {g = "Constant", fg = c.blue},
  {g = "String", fg = c.cyan, style = "italic"},
  {g = "Character", fg = c.blue},
  {g = "Number", fg = c.blue},
  {g = "Boolean", fg = c.blue},
  {g = "Float", fg = c.blue},
  -- -- Identifiers
  -- {g = "Identifier", fg = c.green, style = "bold"},
  -- {g = "Function", fg = c.green, style = "bold"},
  -- -- Statements
  -- {g = "Statement", fg = c.neutral6},
  -- {g = "Conditional", fg = c.neutral6},
  -- {g = "Repeat", fg = c.neutral6},
  -- {g = "Label", fg = c.neutral6},
  -- {g = "Operator", fg = c.neutral6},
  -- {g = "Keyword", fg = c.magenta, style = "bold,italic"},
  -- {g = "Exception", fg = c.neutral6},
  -- -- Preprocs
  -- {g = "PreProc", fg = c.magenta},
  -- {g = "Include", fg = c.magenta, style = "bold,italic"},
  -- {g = "Define", fg = c.magenta},
  -- {g = "Macro"},
  -- {g = "PreCondit", fg = c.magenta},
  -- -- Types
  -- {g = "Type", fg = c.green},
  -- {g = "StorageClass", fg = c.neutral6},
  -- {g = "Structure", fg = c.neutral6},
  -- {g = "Typedef", fg = c.neutral6},
  -- -- Specials
  -- {g = "Special", fg = c.neutral6},
  -- {g = "SpecialChar", fg = c.neutral6},
  -- {g = "Tag", fg = c.neutral6},
  -- {g = "Delimiter", fg = c.cyan},
  -- {g = "SpecialComment", fg = "#4e5166"},
  -- {g = "Debug", fg = c.neutral6},
  -- Underline
  {g = "Underlined", fg = c.yellow, style = "underline"},
  -- Ignore
  {g = "Ignore", fg = c.cyan},
  -- Error
  {g = "Error", fg = c.red, style = "bold,reverse"},
  -- Todos
  {g = "Todo", fg = c.yellow, style = "bold"}
}

-- TreeSitter
-- TSNone               xxx cleared
-- TSPunctDelimiter     xxx links to Delimiter
-- TSPunctBracket       xxx links to Delimiter
-- TSPunctSpecial       xxx links to Delimiter
-- TSConstant           xxx links to Constant
-- TSConstBuiltin       xxx links to Special
-- TSConstMacro         xxx links to Define
-- TSString             xxx links to String
-- TSStringRegex        xxx links to String
-- TSStringEscape       xxx links to SpecialChar
-- TSCharacter          xxx links to Character
-- TSNumber             xxx links to Number
-- TSBoolean            xxx links to Boolean
-- TSFloat              xxx links to Float
-- TSFunction           xxx links to Function
-- TSFuncBuiltin        xxx links to Special
-- TSFuncMacro          xxx links to Macro
-- TSParameter          xxx links to Identifier
-- TSParameterReference xxx links to TSParameter
-- TSMethod             xxx links to Function
-- TSField              xxx links to Identifier
-- TSProperty           xxx links to Identifier
-- TSConstructor        xxx links to Special
-- TSAnnotation         xxx links to PreProc
-- TSAttribute          xxx links to PreProc
-- TSNamespace          xxx links to Include
-- TSConditional        xxx links to Conditional
-- TSRepeat             xxx links to Repeat
-- TSLabel              xxx links to Label
-- TSOperator           xxx links to Operator
-- TSKeyword            xxx links to Keyword
-- TSKeywordFunction    xxx links to Keyword
-- TSKeywordOperator    xxx links to TSOperator
-- TSException          xxx links to Exception
-- TSType               xxx links to Type
-- TSTypeBuiltin        xxx links to Type
-- TSInclude            xxx links to Include
-- TSVariableBuiltin    xxx links to Special
-- TSText               xxx links to TSNone
-- TSStrong             xxx cleared
-- TSEmphasis           xxx cleared
-- TSUnderline          xxx cleared
-- TSTitle              xxx links to Title
-- TSLiteral            xxx links to String
-- TSURI                xxx links to Underlined
-- TSTag                xxx links to Label
-- TSTagDelimiter       xxx links to Delimiter
-- TSPlaygroundFocus    xxx links to Visual

local ts_groups = {
  -- Important variables
  {g = "TSParameter", fg = c.green, style = "bold"},
  {g = "TSFunction", fg = c.green, style = "bold"},
  {g = "TSMethod", fg = c.green, style = "bold"},
  -- Keywords
  {g = "TSInclude", fg = c.cyan, style = "bold,italic"},
  {g = "TSKeyword", fg = c.cyan, style = "bold,italic"},
  -- The rest
  {g = "Comment", fg = c.neutral4},
  {g = "TSString", fg = c.cyan, style = "italic"},
  {g = "TSPunctBracket", fg = c.cyan},
  {g = "TSTag", fg = c.green, style = "bold"},
  {g = "TSTagDelimiter", fg = c.green, style = "bold"}
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

-- Clear highlight groups
local existing = vim.fn.split(vim.api.nvim_exec("hi", true), "\n")
vim.cmd(table.concat(f.map(clear, existing), " | "))

-- Define UI syntax groups
vim.cmd(table.concat(f.map(highlight, builtin_groups), " | "))

-- Define code syntax groups
vim.cmd(table.concat(f.map(highlight, syntax_groups), " | "))

-- Define treesitter code syntax groups
vim.cmd(table.concat(f.map(highlight, ts_groups), " | "))

-- Prevent vim from defining its own highlights
-- See $VIMRUNTIME/syntax/syncolor.vim
vim.g.syntax_cmd = "off"
