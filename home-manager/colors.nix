let

  palettes = builtins.mapAttrs (k: v: builtins.mapAttrs (k: color: { inherit color; }) v) {
    solarized = rec {
      red      = "#dc322f"; # ansi:1    vendor:red
      green    = "#859900"; # ansi:2    vendor:green
      yellow   = "#b58900"; # ansi:3    vendor:yellow
      blue     = "#268bd2"; # ansi:4    vendor:blue
      magenta  = "#d33682"; # ansi:5    vendor:magenta
      cyan     = "#2aa198"; # ansi:6    vendor:cyan
      orange   = "#cb4b16"; # ansi:-    vendor:orange
      violet   = "#6c71c4"; # ansi:-    vendor:violet
      base0    = "#06080a"; # ansi:0,8  vendor:base03 (was #002b36)
      base1    = "#091f2e"; # ansi:9    vendor:base02
      base2    = "#586e75"; # ansi:10   vendor:base01
      base3    = "#657b83"; # ansi:11   vendor:base00
      base4    = "#839496"; # ansi:12   vendor:base0
      base5    = "#93a1a1"; # ansi:13   vendor:base1
      base6    = "#eee8d5"; # ansi:14   vendor:base2
      base7    = "#fdf6e3"; # ansi:7,15 vendor:base3
      black    = base0;
      white    = base7;
    };

    gotham = rec {
      red	     = "#c23127"; # ansi:1     vendor:red
      green    = "#2aa889"; # ansi:2     vendor:green
      yellow	 = "#edb443"; # ansi:3     vendor:yellow
      blue	   = "#195466"; # ansi:4     vendor:blue
      magenta	 = "#888ca6"; # ansi:5     vendor:magenta
      cyan	   = "#33859e"; # ansi:6     vendor:cyan
      orange	 = "#d26937"; # ansi:-     vendor:orange
      violet	 = "#4e5166"; # ansi:-     vendor:violet
      base0	   = "#0c1014"; # ansi:0,8   vendor:base0 (was #0c1014)
      base1	   = "#11151c"; # ansi:9     vendor:base1
      base2	   = "#091f2e"; # ansi:10    vendor:base2
      base3	   = "#0a3749"; # ansi:11    vendor:base3
      base4	   = "#245361"; # ansi:12    vendor:base4
      base5	   = "#599cab"; # ansi:13    vendor:base5
      base6	   = "#99d1ce"; # ansi:14    vendor:base6
      base7	   = "#d3ebe9"; # ansi:7,15  vendor:base7
      black    = base0;
      white    = base7;
    };
  };

  palette = palettes.gotham;

  attrs = {
    bold = { bold = true; };
    italic = { italic = true; };
    underline = { underline = true; };
  };

in

{
  inherit palettes palette attrs;

  theme = with palette; with attrs; rec {
    fg = base6;
    bg = black;
    comment = base4;
    error = red // bold;
    string = cyan // italic;

    # Autocompletion, list selection, etc...
    highlight = yellow;
    suggestionFg = base5;
    suggestionBg = bg;
    suggestionSelectedFg = fg;
    suggestionSelectedBg = bg;

    brGreen = { color = "#39d364"; };
  };
}
