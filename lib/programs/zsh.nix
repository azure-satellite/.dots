{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    profileExtra = with config.home; ''
      source ${homeDirectory}/.zshrc > /dev/null
      source ${profileDirectory}/etc/profile.d/nix.sh > /dev/null
    '';
  };
}

