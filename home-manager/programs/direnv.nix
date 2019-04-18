{ config, pkgs, ... }:

{
  programs = {
    direnv = {
      enable = true;
      config.whitelist.prefix = [
        "${config.lib.paths.userSrc}/mine"
        "${config.lib.paths.userSrc}/smartprocure"
      ];
    };
    fish = {
      interactiveShellInit = ''
        set -xg DIRENV_LOG_FORMAT ""
      '';
    };
  };
}
