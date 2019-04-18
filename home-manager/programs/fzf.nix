{ config, pkgs, ... }:

with pkgs.lib;

let

  FZF_DEFAULT_COMMAND = "command ${config.lib.aliases.rg} --files --no-ignore-vcs";

  # Color options (-1 means use terminal's default)
  fzfColors =
    with builtins;
    with config.lib.colors;
    concatStringsSep "," (attrValues (mapAttrs (k: v: "${k}:${v}") rec {
      # Unselected lines (including input line)
      fg = theme.suggestionFg.color;
      bg = theme.suggestionBg.color;
      hl = theme.highlight.color;

      # Selected line
      "fg+" = theme.suggestionSelectedFg.color;
      "bg+" = theme.suggestionSelectedBg.color;
      "hl+" = theme.highlight.color;

      marker = hl; # Multi-select marker
      info = palette.base5.color; # Results count
      spinner = info; # Streaming input indicator
      header = info; # Header
      border = info; # Border of the preview window and horizontal separators (--border)
      prompt = theme.bg.color; # Prompt. The symbols in "> {query} < 10/10"
      pointer = theme.bg.color; # Pointer to the current line ("> this is the currently selected line")
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
  lib.sessionVariables = { inherit FZF_DEFAULT_COMMAND FZF_DEFAULT_OPTS; };

  programs = {
    fzf = rec {
      enable = true;
      enableBashIntegration = false;
      enableZshIntegration = false;
    };

    # See https://github.com/jethrokuan/fzf
    # Buf after the keybindings setup down there, they end up being:
    # Ctrl-f       | Paste a file in the cmdline.
    # Ctrl-r       | Paste a command from history in the cmdline.
    # (not set)    | cd into sub-directories.
    # Ctrl-t       | cd into sub-directories, including hidden ones.
    # Ctrl-g       | Edit a file/dir with $EDITOR.
    # Ctrl-o       | `xdg-open` or `open` a file/dir>
    fish.interactiveShellInit = ''
      set -U FZF_FIND_FILE_COMMAND ${FZF_DEFAULT_COMMAND}
      set -U FZF_OPEN_COMMAND ${FZF_DEFAULT_COMMAND}

      set -U FZF_ENABLE_OPEN_PREVIEW 0
      set -U FZF_LEGACY_KEYBINDINGS 0

      # I cannot for the life of me figure out where fzf sets these
      bind -e \ec
      bind -e \ct
      if bind -M insert >/dev/null 2>/dev/null
        bind -M insert -e \ec
        bind -M insert -e \ct
      end

      # Erase https://github.com/jethrokuan/fzf plugin unwanted bindings
      bind -e \eo
      bind -e \eO
      bind -e \cr
      bind \cr 'fzf-history-widget'
      bind -e \cf
      bind \cf '__fzf_find_file'
      bind -e \ct
      bind \ct '__fzf_cd --hidden'
      bind -e \co
      bind \co '__fzf_open'
      bind -e \cg
      bind \cg '__fzf_open --editor'
      if bind -M insert >/dev/null 2>/dev/null
        bind -M insert -e \eo
        bind -M insert -e \eO
        bind -M insert -e \cr
        bind -M insert \cr 'fzf-history-widget'
        bind -M insert -e \cf
        bind -M insert \cf '__fzf_find_file'
        bind -M insert -e \ct
        bind -M insert \ct '__fzf_cd --hidden'
        bind -M insert -e \co
        bind -M insert \co '__fzf_open'
        bind -M insert -e \cg
        bind -M insert \cg '__fzf_open --editor'
      end
    '';
  };
}
