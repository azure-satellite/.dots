local c = require("colors")
local f = require("func")

-- :h highlight-groups
local builtin_groups = {
  {g = "StatusLine", fg = c.black, bg = c.base6, style = "bold"},
  {g = "StatusLineNC", fg = c.base6, bg = c.base3, style = "bold"},
  {g = "TabLine", fg = c.base6, bg = c.base3, style = "bold"},
  {g = "TabLineFill", fg = c.base6, bg = c.base3, style = "bold"},
  {g = "TabLineSel", fg = c.black, bg = c.base6, style = "bold"},
  {g = "Cursor", fg = c.black, bg = "#72f970"},
  {g = "CursorColumn", bg = c.base1},
  {g = "CursorLine", bg = c.base2, style = "bold"},
  {g = "CursorLineNr", fg = c.base5, bg = c.base1},
  {g = "ColorColumn", bg = c.base1},
  {g = "DiffAdd", fg = "#859900", style = "bold"},
  {g = "DiffChange"},
  {g = "DiffDelete", fg = "#dc322f", style = "bold"},
  {g = "DiffText", fg = "#268bd2", style = "bold"},
  {g = "TermCursor", fg = c.black, bg = "#72f970"},
  {g = "TermCursorNC", fg = c.black, bg = "#72f970"},
  {g = "FoldColumn", fg = c.blue},
  {g = "Folded", fg = c.blue},
  {g = "VertSplit", fg = c.base6, bg = c.base3, style = "bold"},
  {g = "Visual", fg = c.base3},
  {g = "WarningMsg", fg = "#d26937", style = "bold"},
  {g = "Whitespace", fg = c.blue},
  {g = "WildMenu", fg = c.base7, bg = c.cyan},
  {g = "LineNr", fg = c.blue},
  {g = "Conceal", fg = c.cyan},
  {g = "EndOfBuffer", fg = c.blue},
  {g = "ErrorMsg", fg = c.red, style = "bold"},
  {g = "Directory", fg = c.green},
  {g = "IncSearch", fg = c.yellow, c.base3, style = "bold"},
  {g = "MatchParen", fg = c.base6, bg = "#d26937"},
  {g = "ModeMsg", fg = c.yellow},
  {g = "MoreMsg", fg = c.yellow},
  {g = "NonText", fg = c.blue},
  {g = "Normal", fg = c.base6},
  {g = "Pmenu", fg = c.base6, bg = c.base2},
  {g = "PmenuSel", fg = c.black, bg = c.base6},
  {g = "PmenuSbar", bg = c.base2},
  {g = "PmenuThumb", bg = c.blue},
  {g = "Question", fg = c.yellow},
  {g = "QuickFixLine", c.base2, style = "bold"},
  {g = "Search", fg = c.yellow, bg = c.base3, style = "bold"},
  {g = "SignColumn", fg = c.blue},
  {g = "SpecialKey", fg = c.base3},
  {g = "SpellBad", fg = c.base7, bg = c.red},
  {g = "SpellCap", fg = c.base7, bg = c.blue},
  {g = "SpellLocal", fg = c.yellow},
  {g = "SpellRare", fg = c.base7, bg = "#4e5166"},
  {g = "Substitute", fg = c.yellow, bg = c.base3, style = "bold"},
  {g = "Title", fg = "#d26937"}
}

-- :h group-name
local syntax_groups = {
  -- Comment
  {g = "Comment", fg = c.base4},
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
  -- {g = "Statement", fg = c.base6},
  -- {g = "Conditional", fg = c.base6},
  -- {g = "Repeat", fg = c.base6},
  -- {g = "Label", fg = c.base6},
  -- {g = "Operator", fg = c.base6},
  -- {g = "Keyword", fg = c.magenta, style = "bold,italic"},
  -- {g = "Exception", fg = c.base6},
  -- -- Preprocs
  -- {g = "PreProc", fg = c.magenta},
  -- {g = "Include", fg = c.magenta, style = "bold,italic"},
  -- {g = "Define", fg = c.magenta},
  -- {g = "Macro"},
  -- {g = "PreCondit", fg = c.magenta},
  -- -- Types
  -- {g = "Type", fg = c.green},
  -- {g = "StorageClass", fg = c.base6},
  -- {g = "Structure", fg = c.base6},
  -- {g = "Typedef", fg = c.base6},
  -- -- Specials
  -- {g = "Special", fg = c.base6},
  -- {g = "SpecialChar", fg = c.base6},
  -- {g = "Tag", fg = c.base6},
  -- {g = "Delimiter", fg = c.cyan},
  -- {g = "SpecialComment", fg = "#4e5166"},
  -- {g = "Debug", fg = c.base6},
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
  {g = "Comment", fg = c.base4},
  {g = "TSString", fg = c.cyan, style = "italic"},
  {g = "TSPunctBracket", fg = c.cyan},
  {g = "TSTag", fg = c.green, style = "bold"},
  {g = "TSTagDelimiter", fg = c.green, style = "bold"}
}

-- Make clear command
local function clear(group)
  return string.format("hi clear %s", string.match(group, "^%g+"))
end

-- Make highlight command
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
