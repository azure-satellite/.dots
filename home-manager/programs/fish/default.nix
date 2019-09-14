{ config, pkgs, ... }:

with pkgs.lib;

let

  colors =
    with config.lib.colors;
    with config.lib.colors.palette;
    with config.lib.colors.attrs;
    rec {
      # Command line
      fish_color_normal = { fg = theme.default.fg; };
      fish_color_command = { fg = theme.default.fg; };
      fish_color_quote = theme.string;
      fish_color_redirection = { fg = theme.default.fg; };
      fish_color_end = { fg = theme.default.fg; };
      fish_color_error = theme.error;
      fish_color_param = { fg = base5; };
      fish_color_comment = theme.comment;
      fish_color_match = { fg = green; };
      fish_color_selection = { fg = theme.default.fg; }; # Selected text in Vi mode
      fish_color_operator = { fg = base5; };
      fish_color_escape = { fg = orange; };

      # Prompt
      fish_color_cwd = { fg = green; } // bold;
      fish_color_user = { fg = base5; } // bold;
      fish_color_host = { fg = base5; } // bold;
      fish_color_prompt = { fg = base5; } // bold; # Non-standard. Only for my custom prompt function

      # Others
      fish_color_autosuggestion = theme.comment; # History suggestion when typing a command
      fish_color_cancel = theme.error; # ^C character when canceling a command

      # Autocompletion/pager
      # *_prefix: Highlighted substring
      # *_completion: Suggested string foreground
      # *_background: Suggested string background
      # *_description: Short description next to suggested string

      fish_pager_color_progress = theme.highlight; # Progress bar at the bottom left corner

      # Unselected suggestions
      fish_pager_color_prefix = theme.highlight;
      fish_pager_color_completion = theme.suggestion;
      fish_pager_color_background = theme.suggestion;
      fish_pager_color_description = fish_pager_color_completion // italic;

      # Selected suggestions
      fish_pager_color_selected_prefix = fish_pager_color_prefix;
      fish_pager_color_selected_completion = theme.selectedSuggestion;
      fish_pager_color_selected_background = theme.selectedSuggestion;
      fish_pager_color_selected_description = fish_pager_color_selected_completion // italic;

      # For compatibility until new versions of fish support the variables
      # above (a PR has already been merged)
      fish_color_search_match = fish_pager_color_selected_background;

      # Every second unselected suggestion
      fish_pager_color_secondary_prefix = fish_pager_color_prefix;
      fish_pager_color_secondary_completion = fish_pager_color_completion;
      fish_pager_color_secondary_background = fish_pager_color_background;
      fish_pager_color_secondary_description = fish_pager_color_description;
    };

  colorDefToString =
    with builtins;
    with config.lib.colors.theme;
    with config.lib.colors.palette;
    name: def:
      ''set -U ${name} ${concatStringsSep " " [
        (if hasAttr "fg" def then "'${def.fg}'" else "")
        (if hasAttr "bg" def then "--background='${def.bg}'" else "")
        (if hasAttr "italic" def then "--italics" else "")
        (if hasAttr "bold" def then "--bold" else "")
        (if hasAttr "underline" def then "--underline" else "")
      ]}'';

in

{
  programs = {
    fish = {
      enable = true;

      interactiveShellInit = with config.lib.functions; ''
        set fish_greeting
        ${reduceAttrsToString "\n" (k: v: ''alias --save ${k}="${v}"'') config.lib.aliases}
        set -U fish_prompt_pwd_dir_length 5
        ${reduceAttrsToString "\n" colorDefToString colors}
      '';
    };
  };

  xdg.configFile = {
    "fish/functions" = {
      recursive = true;
      source = ./functions;
    };

    "fish/functions/fisher.fish".source = builtins.fetchurl "https://raw.githubusercontent.com/jorgebucaran/fisher/master/fisher.fish?nocache";

    "fish/fishfile" = {
      onChange = "fish -c fisher";
      text = ''
        jethrokuan/fzf
      '';
    };
  };
}
