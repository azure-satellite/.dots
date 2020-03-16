{ config, pkgs, ... }:

{
  imports = [ ../../lib/common.nix ];

  home.packages = with pkgs; [
    coreutils
    findutils
    openssh
    less
    # This provides terminfo definitions that are not included with the ancient
    # version of ncurses present in OSX
    ncurses
  ];

  programs.gpg.enable = true;

  # There are services.gpg-agent.* options, but those try to start gpg-agent
  # through systemd, and OSX's launchd does it automatically
  home.file.".gnupg/gpg-agent.conf".text = ''
    default-cache-ttl 34560000
    default-cache-ttl-ssh 34560000
    max-cache-ttl 34560000
    max-cache-ttl-ssh 34560000
    pinentry-program ${pkgs.pinentry_mac}/${pkgs.pinentry_mac.binaryPath}
  '';

  programs.fish.loginShellInit = with config.home; ''
    # fenv 'eval $(ssh-agent)' > /dev/null
    fenv source ${profileDirectory}/etc/profile.d/nix.sh > /dev/null
  '';

  programs.alacritty = {
    enable = true;
    settings = {
      shell = {
        program = "${config.home.profileDirectory}/bin/fish";
        args = [ "-l" "-C" "tmux attach -t alacritty || tmux new -t alacritty" ];
      };
      # Alacritty with direct (RGB, true color) color support
      env = { TERM = "alacritty-direct"; };
      font = with config.lib.fonts; {
        normal = { family = mono.name; style = "Regular"; };
        bold = { family = mono.name; style = "Bold"; };
        italic = { family = mono.name; style = "Italic"; };
        bold_italic = { family = mono.name; style = "Bold Italic"; };
        size = 18;
        use_thin_strokes = true;
      };
      draw_bold_text_with_bright_colors = false;
      window = {
        decorations = "none";
        startup_mode = "Fullscreen";
      };
      tabspaces = 2;
      selection.save_to_clipboard = true;
      live_config_reload = false;
      mouse = {
        hide_when_typing = true;
      };
      # Get the chars by running `xxd -psd`. The first two is the CTRL modifier
      # code and the last are the actual keys.
      key_bindings = [
        # Windows
        { key = "T"; mods = "Command"; chars = "\\x02\\x63"; } # New window
        { key = "LBracket"; mods = "Command"; chars = "\\x02\\x70"; } # Select previous window
        { key = "RBracket"; mods = "Command"; chars = "\\x02\\x6e"; } # Select next window
        { key = "Key1"; mods = "Command"; chars = "\\x02\\x31"; } # window 1
        { key = "Key2"; mods = "Command"; chars = "\\x02\\x32"; } # window 2
        { key = "Key3"; mods = "Command"; chars = "\\x02\\x33"; } # window 3
        { key = "Key4"; mods = "Command"; chars = "\\x02\\x34"; } # window 4
        { key = "Key5"; mods = "Command"; chars = "\\x02\\x35"; } # window 5
        { key = "Key6"; mods = "Command"; chars = "\\x02\\x36"; } # window 6
        { key = "Key7"; mods = "Command"; chars = "\\x02\\x37"; } # window 7
        { key = "Key8"; mods = "Command"; chars = "\\x02\\x38"; } # window 8
        { key = "Key9"; mods = "Command"; chars = "\\x02\\x39"; } # window 9
        { key = "W"; mods = "Command"; chars = "\\x02\\x26"; } # Kill window

        # Panes
        { key = "N"; mods = "Command"; chars = "\\x02\\x22"; } # New horizontal pane
        { key = "M"; mods = "Command"; chars = "\\x02\\x25"; } # New vertical pane
        { key = "K"; mods = "Command"; chars = "\\x02\\x1b\\x5b\\x41"; } # Select pane up
        { key = "J"; mods = "Command"; chars = "\\x02\\x1b\\x5b\\x42"; } # Select pane down
        { key = "L"; mods = "Command"; chars = "\\x02\\x1b\\x5b\\x43"; } # Select pane right
        { key = "H"; mods = "Command"; chars = "\\x02\\x1b\\x5b\\x44"; } # Select pane left
        { key = "O"; mods = "Command"; chars = "\\x02\\x7a"; } # Maximize pane
        { key = "Period"; mods = "Command"; chars = "\\x02\\x78"; } # Kill pane

        { key = "R"; mods = "Command|Shift"; chars = "\\x02\\x52"; } # Reload config
      ];
      colors = with config.lib.colors.theme; {
        primary = {
          background = text.bg;
          foreground = text.fg;
        };
        cursor = {
          text = cursor.fg;
          cursor = cursor.bg;
        };
        normal = {
          inherit black red green yellow blue magenta cyan white;
        };
      };
    };
  };

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
      set -g mouse on
      set -g status-position top
      set -g default-shell ${profileDirectory}/bin/fish
      bind c new-window -c "#{pane_current_path}"
      bind \" split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
    '';
  };

  lib.activations.darwin = with config.home; ''
    # https://wiki.archlinux.org/index.php/XDG_Base_Directory
    # This directory has to exist, otherwise ~/.tig_history gets written
    mkdir -p ${config.xdg.dataHome}/tig
    find -L ${profileDirectory}/share/fonts/ -type f -exec cp -f '{}' ${homeDirectory}/Library/Fonts/ \;
  '';
}
