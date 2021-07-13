-- Prevent vim from defining its own highlights
-- See $VIMRUNTIME/syntax/syncolor.vim
vim.g.colors_name = "furnisher"

local c = require("theme")

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
local orangeLight = "#ffebda"

local raised = {fg = c.neutral6, bg = c.neutral3, style = "bold"}
local active = {fg = c.neutral0, bg = c.neutral6, style = "bold"}

-- :h highlight-groups
local ui_groups = {
  -- Cursor
  Cursor = c.cursor,
  TermCursor = c.cursor,
  TermCursorNC = c.cursor,
  CursorColumn = c.raised,
  CursorLine = c.raised,
  CursorLineNr = c.raised,
  -- Statusline
  StatusLine = active,
  StatusLineNC = raised,
  -- Tabline
  TabLine = raised,
  TabLineFill = raised,
  TabLineSel = active,
  -- Diff
  DiffAdd = c.diffAdded,
  DiffDelete = c.diffRemoved,
  DiffText = c.diffChanged,
  DiffChange = {},
  -- Popup menu
  Pmenu = raised,
  PmenuSel = active,
  PmenuSbar = {bg = raised.bg},
  PmenuThumb = {bg = c.neutral4},
  -- Search
  Search = {bg = "#fffc4a"},
  IncSearch = {bg = "#ff9d14"},
  -- Spelling
  SpellBad = {fg = c.neutral7, bg = c.red},
  SpellCap = {fg = c.neutral7, bg = c.blue},
  SpellLocal = {fg = c.yellow},
  SpellRare = {fg = c.neutral7, bg = c.neutral6},
  -- Other
  ColorColumn = {bg = c.neutral1},
  FoldColumn = {fg = c.blue},
  Folded = {fg = c.neutral5, bg = "#f1f8ff"},
  VertSplit = {fg = c.neutral6, bg = c.neutral3, style = "bold"},
  Visual = {bg = "#b5daff"},
  WarningMsg = {fg = orange, style = "bold"},
  Whitespace = {fg = c.blue},
  WildMenu = {fg = c.neutral7, bg = c.cyan},
  LineNr = {fg = c.neutral0, bg = c.neutral6},
  Conceal = {fg = c.cyan},
  EndOfBuffer = {fg = c.blue},
  ErrorMsg = {fg = c.red, style = "bold"},
  Directory = {fg = c.green},
  MatchParen = {fg = c.neutral6, bg = orange},
  ModeMsg = {fg = c.yellow},
  MoreMsg = {fg = c.yellow},
  NonText = {fg = c.blue},
  Normal = c.text,
  Question = {fg = c.yellow},
  QuickFixLine = {c.neutral2, style = "bold"},
  SignColumn = {},
  SpecialKey = {fg = c.neutral3},
  Substitute = {bg = "#fffc4a"},
  Title = {fg = orange}
}

-- :h syntax
local builtin_syntax_groups = {
  -- Comments
  Comment = c.comment, -- Any comment.
  -- Constants
  Constant = c.constant, -- Any constant.
  Boolean = c.constant, -- A boolean constant: TRUE, false.
  String = c.string, -- A string constant: "this is a string".
  Character = c.constant, -- A character constant: 'c', '\n'.
  Number = c.constant, -- A number constant: 234, 0xff.
  Float = c.constant, -- A floating point constant: 2.3e10.
  -- Identifiers
  Identifier = {fg = c.magenta}, -- Any variable name.
  Function = {fg = c.magenta}, -- Function name. Also methods for classes.
  -- Keywords
  Statement = c.keyword, -- Any statement.
  Conditional = c.keyword, -- if, then, else, endif, switch, etc.
  Repeat = c.keyword, -- for, do, while, etc.
  Label = c.keyword, -- case, default, etc.
  Operator = {fg = c.blue}, -- "sizeof", "+", "*", etc.
  Keyword = c.keyword, -- Any other keyword.
  Exception = c.keyword, -- try, catch, throw, etc.
  -- Preprocessor
  PreProc = {}, -- Generic Preprocessor.
  Include = {}, -- Preprocessor #include.
  Define = {}, -- Preprocessor #define.
  Macro = {}, -- Same as Define.
  PreCondit = {}, -- Preprocessor #if, #else, #endif, etc.
  -- Types
  Type = {}, -- int, long, char, etc.
  StorageClass = {}, -- static, register, volatile, etc.
  Structure = {}, -- struct, union, enum, etc.
  Typedef = {}, -- A typedef.
  -- Text styles
  Ignore = {}, -- Left blank, hidden.
  Underlined = {style = "underline"}, -- Text that stands out, HTML links.
  Error = {fg = c.error.fg, bg = c.diffRemoved.bg}, -- Any erroneous construct.
  Todo = {fg = c.green, bg = c.diffAdded.bg}, -- Mostly the keywords TODO FIXME and XXX.
  -- Other
  Special = {fg = c.magenta}, -- Any special symbol.
  SpecialChar = {}, -- Special character in a constant.
  Tag = {fg = c.constant.fg, style = "underline"}, -- You can use CTRL-] on this.
  Delimiter = c.text, -- Character that needs attention.
  SpecialComment = {}, -- Special things inside a comment.
  Debug = {} -- Debugging statements.
}

local s = builtin_syntax_groups

-- :h nvim-treesitter-highlights
local treesitter_syntax_groups = {
  -- Comment
  TSComment = s.Comment, -- Comment blocks.
  -- Constants
  TSConstant = s.Constant, -- Constants.
  TSConstBuiltin = s.Special, -- Constants that are built in the language: `nil` in Lua.
  TSConstMacro = s.Define, -- Constants that are defined by macros: `NULL` in C.
  TSBoolean = s.Boolean, -- Booleans.
  TSString = s.String, -- Strings.
  TSStringRegex = s.String, -- Regexes.
  TSStringEscape = s.SpecialChar, -- Escape characters within a string.
  TSCharacter = s.Character, -- Characters.
  TSNumber = s.Number, -- Numbers.
  TSFloat = s.Float, -- Floats.
  -- Identifiers
  TSFunction = s.Function, -- Function call and definition.
  TSFuncBuiltin = s.Special, -- Builtin functions: `table.insert` in Lua.
  TSFuncMacro = s.Macro, -- Macro defined functions: each `macro_rules` in Rust.
  TSMethod = s.Function, -- Method calls and definitions.
  TSParameter = {}, -- Parameters of a function.
  TSParameterReference = s.Identifier, -- References to parameters of a function.
  TSField = {}, -- Fields.
  TSProperty = c.constant, -- Same as TSField.
  TSConstructor = { fg = orange }, -- Constructor calls and definitions: `{}` in Lua, and Java constructors.
  TSVariable = {}, -- Any variable name that does not have another highlight.
  TSVariableBuiltin = {}, -- Variable names that are defined by the languages, like `this` or `self`.
  TSSymbol = s.Identifier, -- Identifiers referring to symbols or atoms.
  TSTag = {fg = c.green}, -- Tags like html tag names.
  TSNamespace = s.Include, -- Identifiers referring to modules and namespaces.
  -- Keywords
  TSConditional = s.Conditional, -- Keywords related to conditionals.
  TSException = s.Exception, -- Exception related keywords.
  TSKeyword = s.Keyword, -- Keywords that don't fall in the other categories.
  TSKeywordFunction = s.Keyword, -- Keywords used to define a fuction.
  TSKeywordReturn = s.TSKeyword, -- The `return` and `yield` keywords.
  TSLabel = s.Label, -- Labels: `label:` in C and `:label:` in Lua.
  TSRepeat = s.Repeat, -- Keywords related to loops.
  -- Operators
  TSKeywordOperator = s.TSOperator, -- Operators that are English words, e.g. `and`, `as`, `or`.
  TSOperator = s.Operator, -- Any operator: `+`, but also `->` and `*` in C.
  -- Preprocessor
  TSInclude = c.keyword, -- Includes: `#include` in C, `use` or `extern crate` in Rust, or `require` in Lua.
  TSAnnotation = s.PreProc, -- C++/Dart attributes, annotations that can be attached to the code to denote some kind of meta information.
  -- Types
  TSType = s.Type, -- Types.
  TSTypeBuiltin = s.Type, -- Builtin types.
  -- Delimiters
  TSPunctDelimiter = s.Delimiter, -- Delimiters ie: `.`
  TSPunctBracket = s.Delimiter, -- Brackets and parens.
  TSPunctSpecial = s.Delimiter, -- Special punctutation that does not fall in the other catagories.
  TSTagDelimiter = s.Operator, -- Tag delimiter like `<` `>` `/`
  -- Text
  TSText = s.TSNone, -- Strings considered text in a markup language.
  TSTitle = s.Title, -- Text that is part of a title.
  TSLiteral = s.String, -- Literal text.
  TSURI = {fg = c.string.fg, style = "underline"}, -- Any URI like a link or email.
  TSMath = s.Special, -- LaTex-like math environments.
  TSTextReference = s.Constant, -- Footnotes, text references, citations.
  TSEnvironment = s.Macro, -- Text environments of markup languages.
  TSEnvironmentName = s.Type, -- The name/the string indicating the type of text environment.
  -- Text styles
  TSNone = {}, -- No highlighting
  TSEmphasis = {style = "italic"},
  TSStrike = {style = "strikethrough"},
  TSStrong = {style = "bold"},
  TSUnderline = {style = "underline"},
  -- Notes
  TSNote = s.SpecialComment, -- Text representation of an informational note.
  TSWarning = s.Todo, -- Text representation of a warning note.
  TSDanger = s.WarningMsg, -- Text representation of a danger note.
  -- Other
  TSAttribute = s.PreProc, -- [XXX] Unstable.
  TSError = s.Error -- Syntax/parser errors.
}

local t = treesitter_syntax_groups

local language_groups = {
  helpVim = {fg = c.constant.fg, style = "bold"},
  helpSectionDelim = c.constant,
  helpBar = {fg = c.constant.fg, style = "underline"},
  helpHyperTextJump = s.Tag,
  helpStar = t.TSStrong,
  helpHyperTextEntry = t.TSStrong,
  helpSpecial = s.Special,
  helpWarning = t.TSWarning,
  helpOption = {fg = c.green, style = "underline"},
  helpURL = t.TSURI,
  vimFunction = s.Function
}

-- Build highlight command
local function hi(name, def)
  return string.format(
    " hi! %s guifg=%s guibg=%s gui=%s",
    name,
    def.fg or "none",
    def.bg or "none",
    def.style or "none"
  )
end

vim.cmd(join(" | ", map(hi, ui_groups)))
vim.cmd(join(" | ", map(hi, builtin_syntax_groups)))
vim.cmd(join(" | ", map(hi, treesitter_syntax_groups)))
vim.cmd(join(" | ", map(hi, language_groups)))
