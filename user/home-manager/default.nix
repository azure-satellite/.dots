{ config, pkgs, ... }:

{
  imports = [
    ./colors.nix
    ./email.nix
    ./programs/default.nix
    ./modules/default.nix
    # ./desktops/gnome-i3.nix 
    ./desktops/none.nix
  ];

  fonts.fontconfig.enable = true;
  home.keyboard.options = [ "ctrl:swapcaps" ];
  home.packages = with pkgs; [ iosevka fira-code ];
  manual.html.enable = true;
  programs.home-manager.enable = true;
  programs.home-manager.path = "${config.lib.vars.userSrc}/home-manager";
  systemd.user.startServices = true;
  xdg.enable = true;
  xdg.mimeApps.enable = true;

  # Written to ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  # - Sourced by .profile
  # - Sourced by .config/fish/config.fish
  # - Sourced by .xprofile (which also sources .profile)
  home.sessionVariables = with config.home;
  let
    profiles = [ "$HOME/.nix-profile" ];
    dataDirs = pkgs.lib.concatStringsSep ":" (map (profile: "${profile}/share") profiles);
  in
  {
    # Hack to reload session variables on switches
    __HM_SESS_VARS_SOURCED = "";
    # https://github.com/rycee/home-manager/pull/797/files
    XDG_DATA_DIRS          = "${dataDirs}\${XDG_DATA_DIRS:+:}$XDG_DATA_DIRS";
    # https://github.com/NixOS/nixpkgs/issues/38991 
    LOCALE_ARCHIVE         = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    # https://github.com/NixOS/nixpkgs/issues/3382
    GIT_SSL_CAINFO         = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    # Manpages related
    GROFF_NO_SGR           = "1";
    # https://wiki.archlinux.org/index.php/XDG_Base_Directory_support
    PASSWORD_STORE_DIR     = "${homeDirectory}/.local/share/pass";
    LESSKEY                = "${homeDirectory}/.config/less/lesskey";
    LESSHISTFILE           = "${homeDirectory}/.cache/less_history";
    PSQL_HISTORY           = "${homeDirectory}/.cache/postgres_history";
    MYSQL_HISTFILE         = "${homeDirectory}/.cache/mysql_history";
    GEM_HOME               = "${homeDirectory}/.local/share/gem";
    GEM_SPEC_CACHE         = "${homeDirectory}/.cache/gem";
    GOPATH                 = "${homeDirectory}/.local/share";
    WEECHAT_HOME           = "${homeDirectory}/.config/weechat";
    TERMINFO               = "${homeDirectory}/.local/share/terminfo";
    NOTMUCH_CONFIG         = "${homeDirectory}/.config/notmuch/notmuchrc";
    NMBGIT                 = "${homeDirectory}/.local/share/notmuch/nmbug";
    INPUTRC                = "${homeDirectory}/.config/readline/inputrc";
    RUSTUP_HOME            = "${homeDirectory}/.local/share/rustup";
    STACK_ROOT             = "${homeDirectory}/.local/share/stack";
    WGETRC                 = "${homeDirectory}/.config/wgetrc";
    ICEAUTHORITY           = "${homeDirectory}/.cache/ICEauthority";
    SQLITE_HISTORY         = "${homeDirectory}/.cache/sqlite_history";
    DOCKER_CONFIG          = "${homeDirectory}/.config/docker";
  };

  lib.aliases = rec {
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
    less = "less -R";
    map = "xargs -n1";
    maplines = "xargs -n1 -0";
    mongo = "mongo --norc";
    open = "xdg-open";
    dmesg = "dmesg -H";
    node-shell = "set -lx PATH $PWD/node_modules/.bin $PATH; nix-shell -p nodejs yarn";
  };

  lib.vars = rec {
    home = config.home.homeDirectory;
    userBin = "${home}/.nix-profile/bin";
    userSrc = "${home}/Code";
    systemBin = if config.lib.vars.isNixos then "/run/current-system/sw/bin" else "/usr/bin";
  };

  lib.fonts = {
    mono = { name = "Iosevka"; attrs = []; size = 9; };
    sans = { name = "SF Pro Text"; attrs = ["medium"]; size = 9; };
    serif = { name = "SF Pro Text"; attrs = ["medium"]; size = 9; };
    ui = { name = "SF Pro Rounded"; attrs = ["medium"]; size = 9; };
  };

  lib.mimetypes = {
    image = [
      "image/bmp"
      "image/gif"
      "image/jpeg"
      "image/jpg"
      "image/pjpeg"
      "image/png"
      "image/tiff"
      "image/webp"
      "image/x-bmp"
      "image/x-pcx"
      "image/x-png"
      "image/x-portable-anymap"
      "image/x-portable-bitmap"
      "image/x-portable-graymap"
      "image/x-portable-pixmap"
      "image/x-tga"
      "image/x-xbitmap"
    ];
    audio = [
      "application/mxf"
      "application/ogg"
      "application/sdp"
      "application/smil"
      "application/streamingmedia"
      "application/vnd.rn-realmedia"
      "application/vnd.rn-realmedia-vbr"
      "application/x-extension-m4a"
      "application/x-ogg"
      "application/x-smil"
      "application/x-streamingmedia"
      "audio/3gpp"
      "audio/3gpp2"
      "audio/AMR"
      "audio/aac"
      "audio/ac3"
      "audio/aiff"
      "audio/amr-wb"
      "audio/dv"
      "audio/eac3"
      "audio/flac"
      "audio/m3u"
      "audio/m4a"
      "audio/mp1"
      "audio/mp2"
      "audio/mp3"
      "audio/mp4"
      "audio/mpeg"
      "audio/mpeg2"
      "audio/mpeg3"
      "audio/mpegurl"
      "audio/mpg"
      "audio/musepack"
      "audio/ogg"
      "audio/opus"
      "audio/rn-mpeg"
      "audio/scpls"
      "audio/vnd.dolby.heaac.1"
      "audio/vnd.dolby.heaac.2"
      "audio/vnd.dts"
      "audio/vnd.dts.hd"
      "audio/vnd.rn-realaudio"
      "audio/vorbis"
      "audio/wav"
      "audio/webm"
      "audio/x-aac"
      "audio/x-adpcm"
      "audio/x-aiff"
      "audio/x-ape"
      "audio/x-m4a"
      "audio/x-matroska"
      "audio/x-mp1"
      "audio/x-mp2"
      "audio/x-mp3"
      "audio/x-mpegurl"
      "audio/x-mpg"
      "audio/x-ms-asf"
      "audio/x-ms-wma"
      "audio/x-musepack"
      "audio/x-pls"
      "audio/x-pn-au"
      "audio/x-pn-realaudio"
      "audio/x-pn-wav"
      "audio/x-pn-windows-pcm"
      "audio/x-realaudio"
      "audio/x-scpls"
      "audio/x-shorten"
      "audio/x-tta"
      "audio/x-vorbis"
      "audio/x-vorbis+ogg"
      "audio/x-wav"
      "audio/x-wavpack"
    ];
    video = [
      "video/mpeg"
      "video/x-mpeg2"
      "video/x-mpeg3"
      "video/mp4v-es"
      "video/x-m4v"
      "video/mp4"
      "application/x-extension-mp4"
      "video/divx"
      "video/vnd.divx"
      "video/msvideo"
      "video/x-msvideo"
      "video/ogg"
      "video/quicktime"
      "video/vnd.rn-realvideo"
      "video/x-ms-afs"
      "video/x-ms-asf"
      "application/vnd.ms-asf"
      "video/x-ms-wmv"
      "video/x-ms-wmx"
      "video/x-ms-wvxvideo"
      "video/x-avi"
      "video/avi"
      "video/x-flic"
      "video/fli"
      "video/x-flc"
      "video/flv"
      "video/x-flv"
      "video/x-theora"
      "video/x-theora+ogg"
      "video/x-matroska"
      "video/mkv"
      "application/x-matroska"
      "video/webm"
      "video/x-ogm"
      "video/x-ogm+ogg"
      "application/x-ogm"
      "application/x-ogm-audio"
      "application/x-ogm-video"
      "application/x-shorten"
      "video/mp2t"
      "application/x-mpegurl"
      "video/vnd.mpegurl"
      "application/vnd.apple.mpegurl"
      "video/3gp"
      "video/3gpp"
      "video/3gpp2"
      "video/dv"
      "application/x-cue"
    ];
    text = [
      "text/plain"
      "text/html"
      "text/xml"
    ];
    xscheme = [
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/ftp"
    ];
  };

  lib.functions = {
    writeShellScriptsBin = builtins.mapAttrs (name: text:
      let deriv = pkgs.writeShellScriptBin name text;
      in deriv // { bin = "${deriv}/bin/${deriv.name}"; }
    );

    reduceAttrsToString = sep: fn: attrs:
      builtins.concatStringsSep sep (pkgs.lib.mapAttrsToList fn attrs);

    fontConfigString = font: with pkgs.lib.strings;
      "${font.name} ${concatStringsSep " " font.attrs} ${toString font.size}";

    xftString = font: with pkgs.lib.strings;
      "${font.name}:${concatStringsSep ":" font.attrs}:pixelsize=${toString font.size}";

    defaultMimeApp = desktop: mimelist:
      builtins.listToAttrs (builtins.map (mime: { name = mime; value = desktop; }) mimelist);
  };
}
