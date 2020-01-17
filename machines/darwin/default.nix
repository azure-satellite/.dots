{ config, pkgs, ... }:

{
  imports = [ ../../lib/common.nix ];

  home.packages = with pkgs; [
    coreutils
    findutils
    openssh
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
    };
  };
}
