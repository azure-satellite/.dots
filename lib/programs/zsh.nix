{ config, pkgs, ... }:

{
  programs.zsh = rec {
    enable = true;
    dotDir = ".config/zsh";
    profileExtra = with config.home; ''
      source ${profileDirectory}/etc/profile.d/nix.sh > /dev/null
      source ${homeDirectory}/${dotDir}/.zshrc > /dev/null
    '';
  };
}

