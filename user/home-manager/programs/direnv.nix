{ config, pkgs, ... }:

{
  programs = {
    direnv = {
      enable = true;
      stdlib = ''
        source ${./use_nix.sh}
      '';
      config.whitelist.prefix = [
        config.lib.paths.userSrc
      ];
    };
    fish = {
      interactiveShellInit = ''
        set -xg DIRENV_LOG_FORMAT ""
      '';
    };
  };
}
