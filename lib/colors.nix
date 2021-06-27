# TODO:
# - I wish I could write colors in HSL :(
# - ls colors

{ config, pkgs, ... }:

let

attrs = {
  bold = { bold = true; };
  italic = { italic = true; };
  underline = { underline = true; };
  reverse = { reverse = true; };
  undercurl = { undercurl = true; };
  standout = { standout = true; };
};

# s:lightBackground = '#ffffff'
# s:lightBackground2 = '#f6f8fa'
# s:almostBlack ='#24292e'
# s:gray = '#6a737d'
# s:red = '#d73a49'
# s:hardBlue = '#032f62'
# s:blue = '#005cc5'
# s:green = '#22863a'
# s:purple = '#6f42c1'
# s:yellow = '#fffbdd'
# s:orange = '#e36209'
# s:folded = '#f1f8ff'
# s:diffGreen = '#e6ffed'
# s:diffRed = '#ffeef0'
# s:diffText = '#ffea7f'

themes = with attrs; {
  githubLight = rec {
    # Colors
    black   = "#24292e";
    red     = "#d73a49";
    green   = "#22863a";
    yellow  = "#b08800";
    blue    = "#0366d6";
    magenta = "#6f42c1";
    cyan    = "#1b7c83";
    white   = "#ffffff";

    # Grayscale
    neutral0 = "#ffffff";
    neutral1 = "#f6f8fa";
    neutral2 = "#e1e4e8";
    neutral3 = "#d1d5da";
    neutral4 = "#959da5";
    neutral5 = "#6a737d";
    neutral6 = "#586069";
    neutral7 = "#444d56";
    neutral8 = "#2f363d";
    neutral9 = "#24292e";

    # Text
    text = { fg = black; };
    muted = { fg = neutral5; };
    error = { fg = red; } // bold // underline;
    success = { fg = green; } // bold;
    highlight = { fg = "#ffea7f"; bg = neutral9; } // reverse;
    important = { fg = red; } // bold;

    # Syntax elements
    string = { fg = "#032f62"; };
    constant = { fg = "#005cc5"; };
    comment = { fg = neutral5; };
    keyword = { fg = red; };

    # UI
    background = { bg = neutral0; };
    raised = { bg = neutral2; };
    border = { fg = neutral5; };
    cursor = { fg = neutral0; bg = black; };
  };

  gotham = rec {
    # Colors
    black      = neutral0;
    red        = "#c23127";
    green      = "#2aa889";
    yellow     = "#edb443";
    blue       = "#195466";
    magenta    = "#888ca6";
    cyan       = "#33859e";
    white      = neutral7;

    # Grayscale
    neutral0   = "#0c1014";
    neutral1   = "#11151c";
    neutral2   = "#091f2e";
    neutral3   = "#0a3749";
    neutral4   = "#245361";
    neutral5   = "#599cab";
    neutral6   = "#99d1ce";
    neutral7   = "#d3ebe9";

    # Text
    text = { fg = neutral6; bg = neutral0; };
    muted = { fg = neutral4; };
    error = { fg = red; } // bold // underline;
    success = { fg = green; } // bold;
    highlight = { fg = yellow; } // bold;
    important = { fg = neutral6; } // bold;

    # Syntax elements
    string = { fg = cyan; } // italic;
    constant = { fg = cyan; };
    comment = { fg = neutral5; };
    keyword = important;

    # UI
    background = { bg = neutral0; };
    raised = { bg = neutral2; };
    border = { fg = neutral5; };
    cursor = { fg = neutral0; bg = "#72f970"; };
  };
};

theme = themes.githubLight;

i3 = with theme; {
  focused = rec {
    text = text.bg;
    background = background.bg;
    border = neutral5;
    childBorder = border;
    indicator = border;
  };
  unfocused = rec {
    text = text.fg;
    background = background.bg;
    border = neutral2;
    childBorder = border;
    indicator = border;
  };
  # For example: Tab color when it has splits
  focusedInactive = focused // {
    childBorder = unfocused.childBorder;
    indicator = unfocused.indicator;
  };
};

dunst = with theme; {
  global = {
    frame_color = neutral1;
    separator_color = neutral1;
  };
  # Colors taken from https://www.materialpalette.com/colors
  urgency_low = rec {
    background = "#b0bec5";
    foreground = "#000000";
    frame_color = foreground;
  };
  urgency_normal = rec {
    background = "#c5e1a5";
    foreground = "#000000";
    frame_color = foreground;
  };
  urgency_critical = rec {
    background = "#ef9a9a";
    foreground = "#000000";
    frame_color = foreground;
  };
};

st = with theme; {
  "st.color0"      = neutral0;
  "st.color1"      = red;
  "st.color2"      = green;
  "st.color3"      = yellow;
  "st.color4"      = blue;
  "st.color5"      = magenta;
  "st.color6"      = cyan;
  "st.color7"      = neutral7;
  "st.color8"      = neutral0;
  "st.color9"      = neutral1;
  "st.color10"     = neutral2;
  "st.color11"     = neutral3;
  "st.color12"     = neutral4;
  "st.color13"     = neutral5;
  "st.color14"     = neutral6;
  "st.color15"     = neutral7;
  "st.cursorColor" = cursor.bg;
  "st.foreground"  = text.fg;
  "st.background"  = background.bg;
};

alacritty = with theme; {
  primary = { background = background.bg; foreground = text.fg; };
  cursor = { text = cursor.fg; cursor = cursor.bg; };
  normal = { inherit black red green yellow blue magenta cyan white; };
  bright = { inherit black red green yellow blue magenta cyan white; };
};

kitty = with theme; {
  active_tab_background = black;
  active_tab_foreground = neutral6;
  color0 = black;
  color1 = red;
  color2 = green;
  color3 = yellow;
  color4 = blue;
  color5 = magenta;
  color6 = cyan;
  color7 = white;
  color8 = neutral0;
  color9 = neutral1;
  color10 = neutral2;
  color11 = neutral3;
  color12 = neutral4;
  color13 = neutral5;
  color14 = neutral6;
  color15 = neutral7;
  foreground = neutral6;
  background = black;
  cursor = cursor.bg;
  cursor_text_color = cursor.fg;
  selection_background = neutral4;
  selection_foreground = neutral6;
  inactive_border_color = green;
  inactive_tab_background = black;
  inactive_tab_foreground = cyan;
  url_color = cursor.fg;
};

tmux = with theme; rec {
  # "window-style" = { bg = neutral1; };
  # "pane-border-style" = { fg = border.fg; bg = window-style.bg; };
  "pane-border-style" = { fg = border.fg; };
  # "window-active-style" = { bg = neutral0; };
  # "pane-active-border-style" = { fg = border.fg; bg = window-style.bg; };
  "pane-active-border-style" = { fg = border.fg; };
};

fish = with theme; with attrs; {
  # Command line
  fish_color_normal         = text; # Default color
  fish_color_command        = text // bold; # Commands like echo
  fish_color_keyword        = keyword; # Keywords like `if`
  fish_color_quote          = string; # Quoted text like 'abc'
  fish_color_redirection    = text; # IO redirections like >/dev/null
  fish_color_end            = text // bold; # Process separators like ';' and '&'
  fish_color_error          = error; # Syntax errors
  fish_color_param          = text; # Ordinary command parameters
  fish_color_comment        = comment; # Comments
  fish_color_selection      = text; # Selected text in Vi mode
  fish_color_operator       = text; # Parameter expansion operators like '*' and '~'
  fish_color_escape         = text; # Character escapes like 'n' and 'x70'
  fish_color_autosuggestion = muted; # The proposed rest of a command like history completion
  fish_color_cancel         = error; # ^C character on a canceled command
  fish_color_search_match	  = string // bold; # History search matches and selected pager items (background only)

  # Prompt
  fish_color_cwd            = text // bold; # The current working directory in the default prompt
  fish_color_user           = text // bold; # Prompt's username
  fish_color_host           = text // bold; # Prompt's hostname
  fish_color_host_remote    = text // bold; # Remote prompt's host (ex. ssh)

  # Pager: fish will sometimes present a list of choices in a table, called the pager.
  # *_prefix: Highlighted substring
  # *_completion: Item string foreground
  # *_background: Item string background
  # *_description: Short description next to suggested string

  # Item
  fish_pager_color_prefix                = highlight;
  fish_pager_color_completion            = text;
  fish_pager_color_background            = text;
  fish_pager_color_description           = text;

  # Selected item
  fish_pager_color_selected_prefix       = highlight // bold;
  fish_pager_color_selected_completion   = text // bold;
  fish_pager_color_selected_background   = text // bold;
  fish_pager_color_selected_description  = text // bold;

  # Every second item
  fish_pager_color_secondary_prefix      = highlight;
  fish_pager_color_secondary_completion  = text;
  fish_pager_color_secondary_background  = text;
  fish_pager_color_secondary_description = text;

  # Ex. "12 more rows..." at the bottom left
  fish_pager_color_progress              = highlight;

  # Used by the fish_git_prompt function
  # https://fishshell.com/docs/current/cmds/fish_git_prompt.html
  __fish_git_prompt_color_branch      = text // bold;
  __fish_git_prompt_color_dirtystate  = { fg = red; };
  __fish_git_prompt_color_stagedstate = { fg = green; };
};

fzf = with theme; rec {
  # Non-selected line
  "fg"         = "-1";
  "bg"         = "-1";
  "hl"         = "${red}:underline";

  # Selected line
  "fg+"        = "-1";
  "bg+"        = "-1";
  "hl+"        = hl;

  # Other
  "preview-fg" = "-1"; # Preview window
  "preview-bg" = "-1"; # Preview window
  "gutter"     = "-1"; # Gutter on the left
  "query"      = "-1"; # Query string
  "disabled"   = muted.fg; # Query string when search is disabled
  "info"       = "-1"; # Results count
  "border"     = "-1"; # Border around the window (--border and --preview)
  "prompt"     = "-1"; # Prompt. The symbols in "> {query} < 10/10"
  "pointer"    = "-1"; # Pointer to the current line (">")
  "marker"     = "-1"; # Multi-select marker
  "spinner"    = "-1"; # Streaming input indicator
  "header"     = "${important.fg}:bold"; # Header
};

in

{
  lib.colors = {
    inherit attrs theme i3 dunst st alacritty kitty tmux fish fzf;
  };
}
