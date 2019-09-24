{ config, pkgs, ... }:

with config.lib.colors;
with config.lib.colors.palette;
with config.lib.colors.attrs;

let

  higroups = rec {
    StatusLine = { fg = base0; bg = base6; } // bold;
    StatusLineNC = { fg = base6; bg = base3; } // bold;
    # StatusLineTerm
    # StatusLineTermNC

    TabLineSel = StatusLine;
    TabLine = StatusLineNC;
    TabLineFill = TabLine;

    DiffAdd = { fg = "#859900"; } // bold;
    DiffChange = {};
    DiffDelete = { fg = "#dc322f"; } // bold;
    DiffText = { fg = "#268bd2"; } // bold;

    SpellBad = { fg = base7; bg = red; };
    SpellCap = { fg = base7; bg = blue; };
    SpellLocal = { fg = yellow; };
    SpellRare = { fg = base7; bg = violet; };

    Pmenu = { bg = base2; };
    PmenuSel = { fg = base7; bg = blue; };
    PmenuSbar = { bg = base2; };
    PmenuThumb = { bg = blue; };

    Search = theme.highlight // { bg = base3; };
    IncSearch = Search;
    Substitute = Search;
    QuickFixLine = CursorLine;

    # Cursor = theme.cursor;
    TermCursor = theme.cursor;
    TermCursorNC = theme.cursor;
    CursorLine = { bg = base2; } // bold // underline;
    CursorColumn = { bg = base1; };
    CursorLineNr = { fg = base5; bg = base1; };

    ErrorMsg = { fg = red; } // bold;
    WarningMsg = { fg = orange; } // bold;
    MoreMsg = { fg = yellow; };
    ModeMsg = MoreMsg;
    Question = MoreMsg;

    NonText = { fg = blue; };
    EndOfBuffer = NonText;
    Whitespace = NonText;

    # Others
    Normal = { fg = theme.default.fg; };
    SpecialKey = { fg = base3; };
    MatchParen = Normal // { bg = orange; };
    Title = { fg = orange; };
    VertSplit = StatusLineNC;
    ColorColumn = { bg = base1; };
    Visual = { bg = base3; };
    WildMenu = { fg = base7; bg = cyan; };
    Directory = { fg = green; };
    Conceal = { fg = cyan; };
    LineNr = { fg = blue; bg = base1; };
    SignColumn = LineNr;
    Folded = LineNr;
    FoldColumn = LineNr;

    # :h group-name
    Comment = theme.comment;

    Constant = { fg = blue; };
    String = theme.string;
    Character = Constant;
    Number = Constant;
    Boolean = Constant;
    Float = Number;

    Identifier = { fg = green; } // bold;
    Function = Identifier;

    Statement = Normal;
    Conditional = Statement;
    Repeat = Statement;
    Label = Statement;
    Operator = Statement;
    Keyword = Statement;
    Exception = Statement;

    PreProc = { fg = magenta; };
    Include = PreProc;
    Defined = PreProc;
    Macro = {};
    PreCondit = PreProc;

    Type = { fg = green; }; # int, long, char, etc.
    StorageClass = Normal; # static, register, volatile, let, etc.
    Structure = Normal; # struct, union, enum, etc.
    Typedef = Normal; # A typedef

    Special = Normal;
    SpecialChar = Special;
    Tag = Special;
    Delimiter = String;
    SpecialComment = { fg = violet; };
    Debug = Special;

    Underlined = { fg = yellow; } // underline; # text that stands out, HTML links

    Ignore = { fg = cyan; };

    Error = theme.error // reverse;

    Todo = { fg = yellow; } // bold;

    # XML
    xmlAttrib = { fg = magenta; };
    xmlEqual = xmlAttrib;
    xmlTag = { fg = cyan; } // bold;
    xmlTagName = xmlAttrib // bold;
    xmlString = String;

    # HTML
    htmlTag = xmlTag;
    htmlTagName = xmlTagName;
    htmlArg = xmlAttrib;
    htmlTitle = Normal;

    # JS
    jsFuncCall = Normal;
    jsOperator = Operator;
    jsGlobalObjects = Normal;

    jsParens = Normal;
    jsBrackets = jsParens;
    jsBraces = jsParens;
    jsTemplateBraces = String;
    jsStorageClass = Statement;

    jsVariableDef = { fg = green; } // bold;

    jsFuncArgs = jsVariableDef;
    jsFuncParens = jsParens;
    jsFuncArgCommas = jsFuncParens;
    jsFuncBraces = jsFuncParens;
    jsArrowFunction = jsFuncParens;

    jsObjectKey = { fg = base5; };
    jsObjectShorthandProp = jsObjectKey;
    jsFunctionKey = jsObjectKey;
    jsObjectBraces = jsBraces;
    jsObjectColon = jsObjectKey;
    jsObjectSeparator = jsObjectKey;

    jsDestructuringBlock = jsVariableDef;
    jsDestructuringAssignment = jsDestructuringBlock;
    jsDestructuringBraces = jsBraces;
    jsDestructuringNoise = jsDestructuringBraces;
    jsDestructuringPropertyValue = jsVariableDef;

    jsModuleKeyword = jsVariableDef;
    jsModuleBraces = jsDestructuringBraces;
    jsModuleComma = jsDestructuringNoise;

    # Markdown
    
    mkdHeading = Title; 

    # Haskell

    haskellType = Normal;
    # haskellOperators = { fg = green; } // bold;
    haskellLet = { fg = green; } // bold;
    haskellDecl = { fg = magenta; };
    HaskellDerive = haskellDecl;
    haskellDeclKeyword = haskellDecl;
    haskellSeparator = Normal;
    haskellWhere = haskellDecl;
    haskellKeyword = haskellDecl;
  };

  terminalColors = [
    black red green yellow blue magenta cyan white
    base0 base1 base2 base3 base4 base5 base6 base7
  ];

  defaultColorDef = { fg = "NONE"; bg = "NONE"; };

  defaultAttrs = builtins.mapAttrs (k: v: !(v."${k}")) (config.lib.colors.attrs);

  hidef = higroup: colordef:
    let 
      def = defaultColorDef // defaultAttrs // colordef;
      attrs = builtins.concatStringsSep "," (pkgs.lib.remove "" (pkgs.lib.mapAttrsToList
        (k: v: pkgs.lib.optionalString def."${k}" "${k}")
        defaultAttrs
      ));
    in
    ''hi! ${higroup} guifg=${def.fg} guibg=${def.bg} gui=${if attrs != "" then attrs else "NONE"}'';
in

{
  xdg.configFile."nvim/colors/gotham.vim".text = ''
    hi clear
    if exists('syntax_on') | syntax reset | endif
    set background=dark
    let g:colors_name = 'gotham'
    let g:palette = { ${
      config.lib.functions.reduceAttrsToString
      ","
      (name: color: "'${name}': '${color}'")
      palette
    } }
    ${pkgs.lib.concatImapStringsSep "\n"
      (i: v: ''let g:terminal_color_${toString (i - 1)} = "${v}"'') terminalColors}
    ${builtins.concatStringsSep "\n" (pkgs.lib.mapAttrsToList hidef higroups)}
  '';
}
