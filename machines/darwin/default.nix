{ config, pkgs, ... }:

{
  imports = [
    ../../lib/common.nix
    ../../lib/programs/alacritty.nix
    ../../lib/programs/tmux.nix
  ];

  home.packages = with pkgs; [
    coreutils
    findutils
    openssh
    less
    # This provides terminfo definitions that are not included with the ancient
    # version of ncurses present in OSX
    ncurses
    fishPlugins.foreign-env
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

  lib.activations.darwin = with config.home; ''
    # https://wiki.archlinux.org/index.php/XDG_Base_Directory
    find -L ${profileDirectory}/share/fonts/ -type f -exec cp -f '{}' ${homeDirectory}/Library/Fonts/ \;
  '';
}
