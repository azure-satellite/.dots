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
    mono = { name = "iMWritingMonoS Nerd Font"; attrs = []; size = 8; };
    # mono = { name = "Inconsolata Nerd Font"; attrs = []; size = 9; };
    # mono = { name = "FiraCode Nerd Font"; attrs = []; size = 9; };
    # mono = { name = "FantasqueSansMono Nerd Font"; attrs = []; size = 10.5; };
    # mono = { name = "Iosevka Nerd Font"; attrs = []; size = 8; };
    sans = { name = "SF Pro Text"; attrs = ["medium"]; size = 9; };
    serif = { name = "SF Pro Text"; attrs = ["medium"]; size = 9; };
    ui = { name = "SF Pro Rounded"; attrs = ["medium"]; size = 9; };
  };

in

{
  imports = [
    ./colors.nix
    ./programs/direnv.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/node.nix
    ./programs/python.nix
    ./programs/nvim.nix
    ./programs/fish.nix
    ./programs/bash.nix
    ./programs/zsh.nix
  ];

  lib = {
    inherit vars aliases functions fonts;
    activations = {};
  };

  home = {
    packages = [
      bench
      go
      htop
      # This takes too much time to compile
      # (iosevka.override {
      #   set = "slab";
      #   privateBuildPlan = {
      #     family = "Iosevka Slab";
      #     design = [ "slab" ];
      #   };
      # })
      (nerdfonts.override {
        fonts = [ "iA-Writer" ];
      })
      fastmod
      inconsolata
      nixpkgs-fmt
      pandoc
      ripgrep
      tokei
      tealdeer
      tree
      universal-ctags
      youtube-dl
      # XXX: This will get fixed soon
      # wget
    ];

    # Written to ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    # - Sourced by ~/.profile
    # - Sourced by ~/.config/fish/config.fish
    # - Sourced by ~/.xprofile (which also sources .profile)
    sessionVariables = with config.home; with config.xdg; {
      # Hack to reload session variables on switches
      __HM_SESS_VARS_SOURCED = "";

      PATH = builtins.concatStringsSep ":" [
        "./node_modules/.bin"
        "${config.lib.vars.NPM_PACKAGES}/bin"
        "${dataHome}/cargo/bin"
        "${homeDirectory}/.local/bin"
        "${homeDirectory}/google-cloud-sdk/bin"
        "${dataHome}/bin"
        "$PATH"
      ];

      # Manpages related. Don't ask me.
      GROFF_NO_SGR = "1";

      # https://wiki.archlinux.org/index.php/XDG_Base_Directory_support
      LESSKEY = "${configHome}/less/key";
      LESSHISTFILE = "${cacheHome}/less/history";
      PSQL_HISTORY = "${cacheHome}/postgres_history";
      MYSQL_HISTFILE = "${cacheHome}/mysql_history";
      CARGO_HOME = "${dataHome}/cargo";
      GEM_HOME = "${dataHome}/gem";
      GEM_SPEC_CACHE = "${cacheHome}/gem";
      GOPATH = "${dataHome}";
      WEECHAT_HOME = "${configHome}/weechat";
      TERMINFO = "${dataHome}/terminfo";
      INPUTRC = "${configHome}/readline/inputrc";
      RUSTUP_HOME = "${dataHome}/rustup";
      STACK_ROOT = "${dataHome}/stack";
      # WGETRC               = "${configHome}/wgetrc";
      SQLITE_HISTORY = "${cacheHome}/sqlite_history";
      DOCKER_CONFIG = "${configHome}/docker";
      MACHINE_STORAGE_PATH = "${dataHome}/docker-machine";

      # Default applications
      # EDITOR   = "${profileDirectory}/bin/nvim";
      # VISUAL   = "${profileDirectory}/bin/nvim";
      EDITOR = "/usr/local/bin/nvim";
      VISUAL = "/usr/local/bin/nvim";
      PAGER = "${profileDirectory}/bin/less";
      MANPAGER = "${profileDirectory}/bin/less -s -M";
    };

    sessionVariablesExtra = ''
      export LESS_TERMCAP_mb=$'\e[0;1;31m'
      export LESS_TERMCAP_md=$'\e[0;1;31m'
      export LESS_TERMCAP_me=$'\e[0;39m'
      export LESS_TERMCAP_se=$'\e[0;39m'
      export LESS_TERMCAP_so=$'\e[0;1;30;43m'
      export LESS_TERMCAP_ue=$'\e[0;39m'
      export LESS_TERMCAP_us=$'\e[0;1;32m'
    '';
  };

  accounts.email.accounts =
    builtins.mapAttrs (k: v: config.lib.functions.mkGmailAccount (v // { name = k; })) {
      personal = { primary = true; address = "azure.satellite@gmail.com"; };
      sidekick = { address = "panoramic.giggle@gmail.com"; };
      smartprocure = { address = "ahernandez@govspend.com"; };
    };

  nixpkgs.config = import ../stow/.config/nixpkgs/config.nix;

  programs.home-manager = { enable = true; };

  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = toString ../gitmodules/pass;
    };
  };

  xdg.enable = true;

  # https://github.com/rycee/home-manager/issues/589
  home.activation.sideEffects = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    ${stow}/bin/stow -d ${toString ./..} -t ~ stow
    ${builtins.concatStringsSep "\n" (builtins.attrValues config.lib.activations)}
  '';
}
