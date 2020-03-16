{ config, pkgs, ... }:

with pkgs;

let
  vars = with config.home; {
    userSrc = "${homeDirectory}/Code";
    PATH = [ "${homeDirectory}/.local/bin" ];
  };

  aliases = rec {
    cp = "cp -i";
    df = "df -h";
    diff = "diff --color=auto";
    du = "du -ch --summarize";
    fst = "sed -n '1p'";
    snd = "sed -n '2p'";
    ls = "env LC_ALL=C ls --color=auto --group-directories-first";
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
    mono = { name = "Iosevka Slab"; attrs = []; size = 9; };
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
