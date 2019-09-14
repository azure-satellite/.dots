{ config, pkgs, ... }:

let

  mkGmailAccount = { name, address, primary ? false }: {
    inherit primary address;
    realName = "Alejandro Hernandez";
    flavor = "gmail.com";
    passwordCommand = "PASSWORD_STORE_DIR=${config.lib.sessionVariables.PASSWORD_STORE_DIR} ${pkgs.pass}/bin/pass email/${name} | head -n1";
    maildir.path = name;
    smtp.tls.useStartTls = true;
    imap.tls.useStartTls = false;
    msmtp.enable = true;
    mbsync = {
      enable = true;
      create = "both";
      expunge = "both";
      patterns = ["![Gmail]*"];
      extraConfig.channel = {
        CopyArrivalDate = "yes";
      };
    };
  };

  accounts = builtins.mapAttrs (k: v: mkGmailAccount (v // { name = k; })) {
    personal = { primary = true; address = "azure.satellite@gmail.com"; };
    sidekick = { address = "panoramic.giggle@gmail.com"; };
    smartprocure = { address = "ahernandez@govspend.com"; };
  };

  concatAccounts = separator: fn:
    builtins.concatStringsSep separator
      (pkgs.lib.imap1 fn (builtins.attrNames accounts));
in

{
  imports = [ ./programs/mbsync.nix ./programs/neomutt ];

  lib.email = { inherit concatAccounts; };

  programs.msmtp.enable = true;

  accounts.email = {
    inherit accounts;
    maildirBasePath = "${config.home.homeDirectory}/Mail";
  };
}
