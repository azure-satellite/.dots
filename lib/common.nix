{ config, pkgs, ... }:

with pkgs;

{
  imports = [
    ./lib.nix
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

  home = {
    packages = [
      bench
      htop
      (iosevka.override {
        set = "slab";
        privateBuildPlan = {
          family = "Iosevka Slab";
          design = [ "slab" ];
        };
      })
      pandoc
      ripgrep
      tokei
      tealdeer
      tree
      universal-ctags
      youtube-dl
    ];

    # Written to ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    # - Sourced by ~/.profile
    # - Sourced by ~/.config/fish/config.fish
    # - Sourced by ~/.xprofile (which also sources .profile)
    sessionVariables = with config.home; with config.xdg; {
      # Hack to reload session variables on switches
      __HM_SESS_VARS_SOURCED = "";

      PATH = "$PATH:${builtins.concatStringsSep ":" config.lib.vars.PATH}";

      # Manpages related. Don't ask me.
      GROFF_NO_SGR = "1";

      # https://wiki.archlinux.org/index.php/XDG_Base_Directory_support
      LESSKEY              = "${configHome}/less/key";
      LESSHISTFILE         = "${cacheHome}/less/history";
      PSQL_HISTORY         = "${cacheHome}/postgres_history";
      MYSQL_HISTFILE       = "${cacheHome}/mysql_history";
      GEM_HOME             = "${dataHome}/gem";
      GEM_SPEC_CACHE       = "${cacheHome}/gem";
      GOPATH               = "${dataHome}";
      WEECHAT_HOME         = "${configHome}/weechat";
      TERMINFO             = "${dataHome}/terminfo";
      INPUTRC              = "${configHome}/readline/inputrc";
      RUSTUP_HOME          = "${dataHome}/rustup";
      STACK_ROOT           = "${dataHome}/stack";
      WGETRC               = "${configHome}/wgetrc";
      SQLITE_HISTORY       = "${cacheHome}/sqlite_history";
      DOCKER_CONFIG        = "${configHome}/docker";
      MACHINE_STORAGE_PATH = "${dataHome}/docker-machine";

      # Default applications
      # EDITOR   = "${profileDirectory}/bin/nvim";
      # VISUAL   = "${profileDirectory}/bin/nvim";
      EDITOR   = "/usr/local/bin/nvim";
      VISUAL   = "/usr/local/bin/nvim";
      PAGER    = "${profileDirectory}/bin/less";
      MANPAGER = "${profileDirectory}/bin/less -s -M";
    };

    sessionVariablesUnquoted = {
      LESS_TERMCAP_mb = "$'\\e[0;1;31m'";
      LESS_TERMCAP_md = "$'\\e[0;1;31m'";
      LESS_TERMCAP_me = "$'\\e[0;39m'";
      LESS_TERMCAP_se = "$'\\e[0;39m'";
      LESS_TERMCAP_so = "$'\\e[0;1;30;43m'";
      LESS_TERMCAP_ue = "$'\\e[0;39m'";
      LESS_TERMCAP_us = "$'\\e[0;1;32m'";
    };
  };

  accounts.email.accounts =
    builtins.mapAttrs (k: v: config.lib.functions.mkGmailAccount (v // { name = k; })) {
      personal = { primary = true; address = "azure.satellite@gmail.com"; };
      sidekick = { address = "panoramic.giggle@gmail.com"; };
      smartprocure = { address = "ahernandez@govspend.com"; };
    };

  nixpkgs.config = import ../stow/.config/nixpkgs/config.nix;

  programs.home-manager = {
    enable = true;
    path = toString ../gitmodules/home-manager;
  };

  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = toString ../gitmodules/pass;
    };
  };

  xdg.enable = true;

  # https://github.com/rycee/home-manager/issues/589
  home.activation.sideEffects = config.lib.dag.entryAfter ["writeBoundary"] ''
    ${stow}/bin/stow -d ${toString ./..} -t ~ stow
    ${builtins.concatStringsSep "\n" (builtins.attrValues config.lib.activations)}
  '';
}
