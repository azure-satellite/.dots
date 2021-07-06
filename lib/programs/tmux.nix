{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    terminal = "tmux";
    secureSocket = false; # This option is incompatible with Darwin
    baseIndex = 1;
    disableConfirmationPrompt = true;
    escapeTime = 0;
    historyLimit = 50000;
    sensibleOnTop = false;
    extraConfig = with config.home; with config.lib.colors.tmux; ''
      set -g mouse on
      set -g default-shell ${profileDirectory}/bin/fish

      # Enable status bar
      set -g status on

      # Put it on top
      set -g status-position top

      # Put windows list in the center
      set -g status-justify centre

      # Generic statusbar colors
      set -g status-style fg=${status-style.fg},bg=${status-style.bg},bold

      # Active window tab colors
      set -g window-status-current-style bg=${window-status-current-style.bg},fg=${window-status-current-style.fg},bold

      # Set title of window tabs
      setw -g window-status-format ' #W '
      setw -g window-status-current-format ' #W '

      # No left/right components in status bar
      set -g status-left ""
      set -g status-right ""

      bind c new-window -c "#{pane_current_path}"
      bind \" split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      bind "{" swap-window -t -1\; select-window -t -1
      bind "}" swap-window -t +1\; select-window -t +1
    '';
  };
}
