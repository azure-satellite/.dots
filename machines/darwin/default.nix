{ config, pkgs, ... }:

{
  imports = [ ../../lib/common.nix ];

  home.packages = with pkgs; [
    coreutils
    findutils
    openssh
    less
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

  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "alacritty";
      font = {
        normal = { family = "SF Mono"; style = "Regular"; };
        bold = { family = "SF Mono"; style = "Bold"; };
        italic = { family = "SF Mono"; style = "Italic"; };
        bold_italic = { family = "SF Mono"; style = "Bold Italic"; };
        size = 15.0;
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
      shell = let
        tmux = "${config.home.profileDirectory}/bin/tmux";
        script = pkgs.writeShellScriptBin "tmux.sh" ''
          export SHELL="${config.home.profileDirectory}/bin/fish"
          ${tmux} attach -t alacritty 2> /dev/null || ${tmux} new -t alacritty
        '';
      in
      {
        program = "${script}/bin/tmux.sh";
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
    };
  };

  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    # This option is incompatible with Darwin
    secureSocket = false;
    baseIndex = 1;
    disableConfirmationPrompt = true;
    extraConfig = ''
      set -g mouse on
      set -g status-position top
      set -ag terminal-overrides ",${config.programs.alacritty.settings.env.TERM}:RGB"
    '';
  };
}
