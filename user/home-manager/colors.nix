let

  palettes = builtins.mapAttrs (k: v: v // { white = v.base7; black = v.base0; }) {
    solarized = {
      red      = "#dc322f";
      orange   = "#cb4b16";
      yellow   = "#b58900";
      green    = "#859900";
      cyan     = "#2aa198";
      blue     = "#268bd2";
      violet   = "#6c71c4";
      magenta  = "#d33682";
      base0    = "#06080a";
      base1    = "#091f2e";
      base2    = "#586e75";
      base3    = "#657b83";
      base4    = "#839496";
      base5    = "#93a1a1";
      base6    = "#eee8d5";
      base7    = "#fdf6e3";
    };

    gotham = {
      red	     = "#c23127";
      orange	 = "#d26937";
      yellow	 = "#edb443";
      green    = "#2aa889";
      cyan	   = "#33859e";
      blue	   = "#195466";
      violet	 = "#4e5166";
      magenta	 = "#888ca6";
      base0	   = "#0c1014";
      base1	   = "#11151c";
      base2	   = "#091f2e";
      base3	   = "#0a3749";
      base4	   = "#245361";
      base5	   = "#599cab";
      base6	   = "#99d1ce";
      base7	   = "#d3ebe9";
    };

    nordLight = {
      red     = "#BF616A";
      orange  = "#D08770";
      yellow  = "#EBCB8B";
      green   = "#A3BE8C";
      cyan    = "#88C0D0";
      blue    = "#8FBCBB";
      violet  = "#5E81AC";
      magenta = "#B48EAD";
      base0   = "#2E3440";
      base1   = "#3B4252";
      base2   = "#434C5E";
      base3   = "#4C566A";
      base4   = "#616E88";
      base5   = "#D8DEE9";
      base6   = "#E5E9F0";
      base7   = "#ECEFF4";
    };

    materialLight = {
      red     = "#af0000";
      orange  = "#fb8c00";
      yellow  = "#fdd835";
      green   = "#43a047";
      cyan    = "#00acc1";
      blue    = "#3949ab";
      violet  = "#5e35b1";
      magenta = "#8e24aa";
      base0   = "#ffffff";
      base1   = "#cccccc";
      base2   = "#aaaaaa";
      base3   = "#888888";
      base4   = "#666666";
      base5   = "#444444";
      base6   = "#222222";
      base7   = "#000000";
    };
  };

  others = {
    brGreen = "#00ff00";
  };

  palette = palettes.gotham;

  attrs = {
    bold = { bold = true; };
    italic = { italic = true; };
    underline = { underline = true; };
    reverse = { reverse = true; };
    undercurl = { undercurl = true; };
    standout = { standout = true; };
  };

  theme = with palette; with attrs; rec {
    default = { fg = base6; bg = base0; };

    cursor = { bg = others.brGreen; };

    comment = { fg = base4; };
    error = { fg = red; } // bold;
    string = { fg = cyan; } // italic;

    # Autocompletion, list selection, etc...
    highlight = { fg = yellow; } // bold;
    suggestion = { fg = base5; };
    selectedSuggestion = { fg = base6; } // bold;
  };

in

{
  inherit palettes palette attrs others theme;
}
