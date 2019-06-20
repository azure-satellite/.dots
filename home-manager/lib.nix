{ config, pkgs, ... }:

let

  ls = "env LC_ALL=C ls --color=auto --group-directories-first";

  HOME = config.home.homeDirectory;

  functions = {
    writeShellScriptsBin = builtins.mapAttrs (name: text:
      let deriv = pkgs.writeShellScriptBin name text;
      in deriv // { bin = "${deriv}/bin/${deriv.name}"; }
    );

    reduceAttrsToString = sep: fn: attrs:
      builtins.concatStringsSep sep (pkgs.lib.mapAttrsToList fn attrs);
  };

  aliases = {
    node-shell = "set -lx PATH $PWD/node_modules/.bin $PATH; nix-shell -p nodejs yarn";
    rg = "rg --glob '!{.git}/*' --smart-case --hidden";
    config = "git --git-dir=${HOME}/.dotfiles --work-tree=${HOME}";
    cp = "cp -i";
    df = "df -h";
    diff = "diff --color=auto";
    du = "du -ch --summarize";
    fst = "sed -n '1p'";
    snd = "sed -n '2p'";
    git = "hub";
    grep = "grep --color=auto";
    inherit ls;
    la = "${ls} -a";
    ll = "${ls} -lh";
    l = "${ls} -alh";
    less = "less -R";
    map = "xargs -n1";
    maplines = "xargs -n1 -0";
    mail = "neomutt";
    mongo = "mongo --norc";
    p2 = "python2";
    p3 = "python3";
    open = "xdg-open";
    pkgs = "nix-store --query --requisites /run/current-system | cut -d- -f2- | sort | uniq";
    tree = "tree -shaC --dirsfirst -I .git";
    dmesg = "dmesg -H";
    cp-png = "${pkgs.xclip}/bin/xclip -selection clipboard -t image/png";
  };

  paths = rec {
    userBin = "${HOME}/.nix-profile/bin";
    systemBin = "/run/current-system/sw/bin";
    userSrc = "${HOME}/Code";
  };

  # These will also be available to programs who don't get started from a
  # shell
  #
  # Written to ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  # - Sourced by .profile
  # - Sourced by .config/fish/config.fish
  # - Sourced by .xprofile (which also sources .profile)
  sessionVariables = rec {
    # Hack to get home-manager to reload session variables on switches
    __HM_SESS_VARS_SOURCED = "";

    # Default applications
    # The whole userBin thing is so these variables point to the correct one
    # if we build a different version
    BROWSER = "${paths.userBin}/chromium";
    TERMINAL = "${paths.userBin}/st";
    EDITOR = "${paths.userBin}/nvim";
    VISUAL = "${EDITOR}";
    MAILER = "${paths.userBin}/neomutt";
    PAGER = "${paths.systemBin}/less";
    MANPAGER = "${paths.systemBin}/less -s -M";

    # HiDPI stuff
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";

    # See https://github.com/NixOS/nixpkgs/issues/3382
    SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    GIT_SSL_CAINFO = "${SSL_CERT_FILE}";
    # Make Python remember history (default repl sucks)
    PYTHONSTARTUP = "${HOME}/.local/share/python/startup.py";
    # Big discussion at Nixpkgs. Can't remember why it's here but it fixes shit.
    GDK_PIXBUF_MODULE_FILE = "${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache";
    # Manpages related
    GROFF_NO_SGR = "1";

    # Home directory cleanup. See
    # https://wiki.archlinux.org/index.php/XDG_Base_Directory_support
    PASSWORD_STORE_DIR = "${HOME}/.local/share/pass";
    IPYTHONDIR = "${HOME}/.config/jupyter";
    PYTHON_HISTFILE = "${HOME}/.cache/python_history";
    PIP_LOG = "${HOME}/.cache/pip/pip.log";
    PYLINTHOME = "${HOME}/.cache/pylint";
    LESSKEY = "${HOME}/.config/less/lesskey";
    LESSHISTFILE = "${HOME}/.cache/less_history";
    PSQL_HISTORY = "${HOME}/.cache/postgres_history";
    MYSQL_HISTFILE = "${HOME}/.cache/mysql_history";
    GEM_HOME = "${HOME}/.local/share/gem";
    GEM_SPEC_CACHE = "${HOME}/.cache/gem";
    GOPATH = "${HOME}/.local/share";
    WEECHAT_HOME = "${HOME}/.config/weechat";
    TERMINFO = "${HOME}/.local/share/terminfo";
    NOTMUCH_CONFIG = "${HOME}/.config/notmuch/notmuchrc";
    NMBGIT = "${HOME}/.local/share/notmuch/nmbug";
    PYTHON_EGG_CACHE = "${HOME}/.cache/python-eggs";
    INPUTRC = "${HOME}/.config/readline/inputrc";
    RUSTUP_HOME = "${HOME}/.local/share/rustup";
    STACK_ROOT = "${HOME}/.local/share/stack";
    WGETRC = "${HOME}/.config/wgetrc";
    ICEAUTHORITY = "${HOME}/.cache/ICEauthority";
    SQLITE_HISTORY = "${HOME}/.cache/sqlite_history";
    GTK2_RC_FILES = "${HOME}/.config/gtk-2.0/gtkrc";
    DOCKER_CONFIG = "${HOME}/.config/docker";
  };
in

with config; {
  lib = {
    colors = import ./colors.nix;
    inherit functions aliases paths sessionVariables;
  };
}
