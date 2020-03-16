{ config, pkgs, ... }:

with pkgs.lib;

let

  FZF_DEFAULT_COMMAND = "command ${config.lib.aliases.rg} --files --no-ignore-vcs";

  # Color options (-1 means use terminal's default)
  fzfColors =
    with builtins;
    with config.lib.colors.theme;
    concatStringsSep "," (attrValues (mapAttrs (k: v: "${k}:${v}") rec {
      # Unselected lines (including input line)
      fg = suggestion.fg;
      bg = "-1";
      hl = highlight.fg;

      # Selected line
      "fg+" = selectedSuggestion.fg;
      "bg+" = "-1"; # Setting a background makes a fringe on the left :(
      "hl+" = highlight.fg;

      marker = hl; # Multi-select marker
      info = base5; # Results count
      spinner = info; # Streaming input indicator
      header = info; # Header
      border = info; # Border of the preview window and horizontal separators (--border)
      prompt = "-1"; # Prompt. The symbols in "> {query} < 10/10"
      pointer = "-1"; # Pointer to the current line ("> this is the currently selected line")
    }));

  FZF_DEFAULT_OPTS = toString [
    "--color=${fzfColors}"
    "--cycle"
    "--filepath-word"
    "--inline-info"
    "--reverse"
    "--preview='head -100 {}'"
    "--preview-window=right:hidden"
    "--bind=ctrl-space:toggle-preview"
  ];

in

{
  home.sessionVariables = { inherit FZF_DEFAULT_COMMAND FZF_DEFAULT_OPTS; };

  programs = {
    fzf = rec {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = false;
      enableZshIntegration = false;
    };

    fish.interactiveShellInit = ''
      bind -e \ec
      bind \co fzf-cd-widget
      if bind -M insert >/dev/null 2>/dev/null
        bind -M insert -e \ec
        bind -M insert \co fzf-cd-widget
      end
    '';
  };
}
