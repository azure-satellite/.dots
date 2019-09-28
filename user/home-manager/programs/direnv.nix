{ config, pkgs, ... }:

{
  programs = {
    direnv = {
      enable = true;
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
