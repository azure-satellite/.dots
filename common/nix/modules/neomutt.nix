{ config, lib, pkgs, ...}:

with lib;

let

  cfg = config.programs.neomutt;

  mkAccountFile = name:
    let acct = builtins.getAttr name config.accounts.email.accounts; in
    pkgs.writeText "${name}_account" ''
      set from = "${acct.address}"
      set hostname = "gmail.com"
      set sendmail = "${pkgs.msmtp}/bin/msmtp -a ${name} --tls-trust-file=${acct.smtp.tls.certificatesFile}"
      set spoolfile = +${name}/Inbox
      set mbox      = +${name}/All
      set record    = +${name}/Sent
      set postponed = +${name}/Drafts
      set trash     = +${name}/Trash
      mailboxes $spoolfile $record $postponed $trash $mbox +${name}/Spam
      macro index,pager m? "<save-message>?<enter>" "Move message to mailbox"
      macro index,pager ma "<save-message>$mbox<enter>" "Move message to archive"
      macro index,pager mi "<save-message>$spoolfile<enter>" "Move message to inbox"
    '';

  mkFolderHook = name: shortcut: ''
    folder-hook =${name}/* source ${mkAccountFile name}
    macro index,pager ${shortcut} "<change-folder>=${name}/Inbox<enter><check-stats>"
    push ${shortcut}
  '';

  concatAccounts = separator: fn:
    builtins.concatStringsSep separator
      (pkgs.lib.imap1 fn (builtins.attrNames config.accounts.email.accounts));

  mailcap = pkgs.writeText "mailcap" ''
    image/jpg; ${./view_attachment.sh} %s jpg
    image/jpeg; ${./view_attachment.sh} %s jpg
    image/pjpeg; ${./view_attachment.sh} %s jpg
    image/png; ${./view_attachment.sh} %s png
    image/gif; ${./view_attachment.sh} %s gif
    application/pdf; ${./view_attachment.sh} %s pdf
    text/html; ${./view_attachment.sh} %s html
    application/octet-stream; ${./view_attachment.sh} %s "-"
  '';

in

{
  options.programs.neomutt = {
    enable = mkEnableOption ''
      Neomutt
    '';

    config = mkOption {
      type = types.str;
      description = ''
        Extra configuration
      '';
      example = ''
        set history_file = ~/.cache/mutt/history
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.neomutt pkgs.urlview ];
    home.file.".urlview".text = "COMMAND xdg-open %s";

    xdg.dataFile."applications/neomutt.desktop".text = ''
      [Desktop Entry]
      Name=Neomutt
      Comment=Email client
      Exec=neomutt %U
      Terminal=true
      Type=Application
      Icon=terminal
      Categories=Email;
    '';

    xdg.configFile."mutt/muttrc".text = ''
      ${cfg.config}
      ${concatAccounts "\n" (i: v: mkFolderHook v "<F${toString i}>")}
      set mailcap_path = "${mailcap}"
    '';
  };
}
