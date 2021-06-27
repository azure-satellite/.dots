{ config, pkgs, ... }:

# set -g window-style "bg=${window-style.bg}"
# set -g pane-border-style "fg=${pane-border-style.fg} bg=${pane-border-style.bg}"
# set -g window-active-style "bg=${window-active-style.bg}"
# set -g pane-active-border-style "fg=${pane-active-border-style.fg} bg=${pane-active-border-style.bg}"

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
    extraConfig = with config.home; with config.lib.colors.tmux; ''
      set -g status off
      set -g mouse on
      set -g default-shell ${profileDirectory}/bin/fish

      set -g pane-border-style "fg=${pane-border-style.fg}"
      set -g pane-active-border-style "fg=${pane-active-border-style.fg}"

      bind c new-window -c "#{pane_current_path}"
      bind \" split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
    '';
  };
}
