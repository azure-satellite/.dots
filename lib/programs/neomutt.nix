{ config, pkgs, ... }:

{
  programs.neomutt = {
    enable = true;
    config = ''
      ${builtins.readFile ./neomutt/colors}
      ${builtins.readFile ./neomutt/unbindings}
      ${builtins.readFile ./neomutt/bindings}
      ${builtins.readFile ./neomutt/muttrc}
      set history_file = "${config.home.homeDirectory}/.cache/mutt/history"
      set folder = "${config.accounts.email.maildirBasePath}"
    '';
  };

  lib.aliases.mail = "neomutt";
}
