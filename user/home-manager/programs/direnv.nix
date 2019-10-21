{ config, pkgs, ... }:

{
  programs = {
    direnv = {
      enable = true;
      config.whitelist.prefix = [
        config.lib.vars.userSrc
      ];
    };
    fish = {
      interactiveShellInit = ''
        set -xg DIRENV_LOG_FORMAT ""
      '';
    };
  };
}
