{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    terminal = "tmux";
    # This option is incompatible with Darwin
    secureSocket = false;
    baseIndex = 1;
    disableConfirmationPrompt = true;
    escapeTime = 0;
    historyLimit = 50000;
    sensibleOnTop = false;
    extraConfig = with config.home; ''
      set -g status off
      set -g mouse on
      set -g default-shell ${profileDirectory}/bin/fish
      bind c new-window -c "#{pane_current_path}"
      bind \" split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
    '';
  };
}
