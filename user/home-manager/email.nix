{ config, pkgs, ... }:

let

  mkGmailAccount = { name, address, primary ? false }: {
    inherit primary address;
    realName = "Alejandro Hernandez";
    flavor = "gmail.com";
    passwordCommand = "PASSWORD_STORE_DIR=${config.home.sessionVariables.PASSWORD_STORE_DIR} ${pkgs.pass}/bin/pass email/${name} | ${pkgs.coreutils}/bin/head -n1";
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

in

{
  imports = [ ./programs/mbsync.nix ];

  programs.msmtp.enable = true;

  accounts.email = {
    inherit accounts;
    maildirBasePath = "${config.lib.vars.home}/Mail";
  };
}
