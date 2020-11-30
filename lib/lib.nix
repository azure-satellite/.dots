{ config, pkgs, ... }:

with pkgs;

let
  vars = with config.home; {
    userSrc = "${homeDirectory}/Code";
  };

  aliases = rec {
    cp = "cp -i";
    df = "df -h";
    diff = "diff --color=auto";
    du = "du -ch --summarize";
    fst = "sed -n '1p'";
    snd = "sed -n '2p'";
    # Using the full path to avoid some recursion issue when trying
    # to complete
    ls = "LC_ALL=C ${coreutils}/bin/ls --color=auto --group-directories-first";
    la = "${ls} -a";
    ll = "${ls} -lh";
    l = "${ls} -alh";
    map = "xargs -n1";
    maplines = "xargs -n1 -0";
    mongo = "mongo --norc";
    dmesg = "dmesg -H";
    cloc = "tokei";
    rg = "rg --glob '!package-lock.json' --glob '!.git/*' --smart-case --hidden";
    grep = config.lib.aliases.rg;
    tree = "tree -a --dirsfirst -I .git";
    tl = "tldr";
    less = "less -R";
    p = config.home.sessionVariables.PAGER;
  };

  functions = {
    writeShellScriptsBin = builtins.mapAttrs (name: text:
      let deriv = writeShellScriptBin name text;
      in deriv // { bin = "${deriv}/bin/${deriv.name}"; }
    );

    reduceAttrsToString = sep: fn: attrs:
      builtins.concatStringsSep sep (lib.mapAttrsToList fn attrs);

    mkGmailAccount = { name, address, primary ? false }: {
      inherit primary address;
      realName = "Alejandro Hernandez";
      flavor = "gmail.com";
    };
  };

  fonts = {
    mono = { name = "iMWritingMonoS Nerd Font"; attrs = []; size = 9.5; };
    # mono = { name = "Inconsolata Nerd Font"; attrs = []; size = 11; };
    # mono = { name = "FiraCode Nerd Font"; attrs = []; size = 9; };
    # mono = { name = "FantasqueSansMono Nerd Font"; attrs = []; size = 10.5; };
    # mono = { name = "Iosevka Nerd Font"; attrs = []; size = 10; };
    sans = { name = "SF Pro Text"; attrs = ["medium"]; size = 9; };
    serif = { name = "SF Pro Text"; attrs = ["medium"]; size = 9; };
    ui = { name = "SF Pro Rounded"; attrs = ["medium"]; size = 9; };
  };

in
{
  imports = [
    ./colors.nix
  ];

  lib = {
    inherit vars aliases functions fonts;
    activations = {};
  };
}
