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
      # Alacritty with direct (RGB, true color) color support
      env = { TERM = "alacritty-direct"; };
      window = {
        decorations = "none";
        startup_mode = "Fullscreen";
      };
      # background_opacity = 0.7;
      font = with config.lib.fonts; {
        normal = { family = mono.name; style = "Regular"; };
        bold = { family = mono.name; style = "Bold"; };
        italic = { family = mono.name; style = "Italic"; };
        bold_italic = { family = mono.name; style = "Bold Italic"; };
        size = mono.size * 2;
        use_thin_strokes = true;
      };
      colors = with config.lib.colors.theme; {
        primary = { background = text.bg; foreground = text.fg; };
        cursor = { text = cursor.fg; cursor = cursor.bg; };
        normal = { inherit black red green yellow blue magenta cyan white; };
      };
      shell = {
        program = "${config.home.profileDirectory}/bin/fish";
        args = [ "-l" "-C" "tmux attach -t alacritty || tmux new -t alacritty" ];
      };
      live_config_reload = false;
      selection = { save_to_clipboard = true; };
      mouse = { hide_when_typing = true; };
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
      set -g status-position bottom
      set -g default-shell ${profileDirectory}/bin/fish
      bind c new-window -c "#{pane_current_path}"
      bind \" split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
    '';
  };

  programs.kitty = {
    enable = true;
    settings = with config.lib.colors.theme; with config.lib.fonts; with config.home; {
      active_border_color = "none";
      active_tab_font_style = "normal";
      active_tab_background = black;
      active_tab_foreground = base6;
      background = black;
      clear_all_shortcuts = "yes";
      close_on_child_death = "yes";
      color0 = black;
      color1 = red;
      color2 = green;
      color3 = yellow;
      color4 = blue;
      color5 = magenta;
      color6 = cyan;
      color7 = white;
      color8 = base0;
      color9 = base1;
      color10 = base2;
      color11 = base3;
      color12 = base4;
      color13 = base5;
      color14 = base6;
      color15 = base7;
      cursor = cursor.bg;
      cursor_text_color = cursor.fg;
      copy_on_select = "yes";
      cursor_blink_interval = 0;
      disable_ligatures = "always";
      enabled_layouts = "splits,stack";
      font_family = mono.name;
      font_size = 17;
      foreground = base6;
      inactive_border_color = green;
      inactive_tab_background = black;
      inactive_tab_font_style = "normal";
      inactive_tab_foreground = cyan;
      input_delay = 10;
      repaint_delay = 50;
      kitty_mod = "cmd";
      macos_quit_when_last_window_closed = "yes";
      macos_thicken_font = "0.75";
      placement_strategy = "top-left";
      rectangle_select_modifiers = "cmd";
      selection_background = base4;
      selection_foreground = base6;
      shell = "${profileDirectory}/bin/fish --login";
      strip_trailing_spaces = "smart";
      tab_bar_min_tabs = 1;
      tab_bar_style = "separator";
      tab_separator = "│";
      tab_title_template = "{title}";
      url_color = cursor.fg;
      url_style = "curly";
    };
    keybindings = {
      "cmd+0"       = "change_font_size all 0";
      "cmd+1"       = "goto_tab 1";
      "cmd+2"       = "goto_tab 2";
      "cmd+3"       = "goto_tab 3";
      "cmd+4"       = "goto_tab 4";
      "cmd+5"       = "goto_tab 5";
      "cmd+6"       = "goto_tab 6";
      "cmd+7"       = "goto_tab 7";
      "cmd+8"       = "goto_tab 8";
      "cmd+9"       = "goto_tab 9";
      "cmd+["       = "previous_tab";
      "cmd+]"       = "next_tab";
      "cmd+c"       = "copy_to_clipboard";
      "cmd+down"    = "resize_window shorter 5";
      "cmd+equal"   = "change_font_size all +1.0";
      "cmd+h"       = "neighboring_window left";
      "cmd+j"       = "neighboring_window down";
      "cmd+k"       = "neighboring_window up";
      "cmd+l"       = "neighboring_window right";
      "cmd+left"    = "resize_window narrower 5";
      "cmd+m"       = "launch --cwd=current --location=vsplit";
      "cmd+minus"   = "change_font_size all -1.0";
      "cmd+n"       = "launch --cwd=current --location=hsplit";
      "cmd+o"       = "next_layout";
      "cmd+right"   = "resize_window wider 5";
      "cmd+shift+[" = "move_tab_backward";
      "cmd+shift+]" = "move_tab_forward";
      "cmd+shift+h" = "move_window left";
      "cmd+shift+j" = "move_window down";
      "cmd+shift+k" = "move_window up";
      "cmd+shift+l" = "move_window right";
      "cmd+t"       = "new_tab_with_cwd";
      "cmd+up"      = "resize_window taller 5";
      "cmd+v"       = "paste_from_clipboard";
      "cmd+w"       = "close_tab";
      "cmd+x"       = "close_window";
    };
  };

  lib.activations.darwin = with config.home; ''
    # https://wiki.archlinux.org/index.php/XDG_Base_Directory
    # This directory has to exist, otherwise ~/.tig_history gets written
    mkdir -p ${config.xdg.dataHome}/tig
    find -L ${profileDirectory}/share/fonts/ -type f -exec cp -f '{}' ${homeDirectory}/Library/Fonts/ \;
  '';
}
