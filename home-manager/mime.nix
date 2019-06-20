{ config, pkgs, ... }:

let

  scripts = config.lib.functions.writeShellScriptsBin (with pkgs; {
    dontFail = ''"$@" || true'';

    runNeomutt = ''
      [ "$1" == "mailto:" ] && mailto="mailto::" || mailto="$@"
      ${neomutt}/bin/neomutt $mailto
    '';
  });

  desktops = with pkgs; with config.lib.sessionVariables; {
    neomutt = {
      name = "Mutt";
      generic = "Mail client";
      comment = "A simple and flexible terminal mail client";
      exec = "${TERMINAL} ${scripts.runNeomutt.bin}";
      params = "%u";
    };

    neovim = {
      name = "Neovim";
      generic = "Text Editor";
      comment = "Open source modal text editor";
      exec = "${TERMINAL} ${neovim}/bin/nvim";
      params = "%F";
      # MimeType=text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;
    };

    # emacs = {
    #   name = "Emacs (Client)";
    #   generic = "Text Editor";
    #   comment = "Open source Lisp-based text editor";
    #   exec = "emacsclient --create-frame --alternate-editor=emacs";
    #   params = "%F";
    #   # MimeType=text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;
    # };

    chromium = {
      name = "Chromium";
      generic = "Web browser";
      comment = "Open source web browser from Google";
      exec = "${chromium}/bin/chromium";
      params = "%U";
      # MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;x-scheme-handler/mailto;x-scheme-handler/webcal;x-scheme-handler/about;x-scheme-handler/unknown
    };

    firefox = {
      name = "Firefox";
      generic = "Web browser";
      comment = "Open source web browser from Mozilla";
      exec = "${firefox}/bin/firefox";
      params = "%U";
    };

    zathura = {
      name = "Zathura";
      generic = "Document viewer";
      comment = "Minimalistic document viewer";
      exec = "${zathura}/bin/zathura";
      params = "%U";
    };

    transmission = {
      name = "Transmission";
      generic = "BitTorrent client";
      comment = "Download and share files over BitTorrent";
      exec = "${transmission-gtk}/bin/transmission-gtk";
      params = "%U";
      startupNotify = true;
    };

    mcomix = {
      name = "MComix";
      generic = "Comic book viewer";
      comment = "Minimalistic comic book viewer";
      exec = "${mcomix}/bin/mcomix";
      params = "%f";
      startupNotify = true;
      # MimeType=application/x-cb7;application/x-ext-cb7;application/x-cbr;application/x-ext-cbr;application/x-cbt;application/x-ext-cbt;application/x-cbz;application/x-ext-cbz;application/pdf;application/x-pdf;application/x-ext-pdf;image/bmp;image/x-MS-bmp;image/x-bmp;image/gif;image/jpeg;image/png;image/tiff;image/x-portable-bitmap;image/x-portable-graymap;image/x-portable-pixmap;
    };

    calibre = {
      name = "Calibre";
      generic = "E-book library manager";
      comment = "Manage, convert, edit, and read e-books";
      exec = "${calibre}/bin/calibre";
      params = "%F";
      # MimeType=application/vnd.openxmlformats-officedocument.wordprocessingml.document;text/html;application/x-cbc;application/ereader;application/oebps-package+xml;image/vnd.djvu;application/x-sony-bbeb;application/vnd.ms-word.document.macroenabled.12;text/rtf;text/x-markdown;application/pdf;application/x-cbz;application/x-mobipocket-ebook;application/x-cbr;application/x-mobi8-ebook;text/fb2+xml;application/vnd.oasis.opendocument.text;application/epub+zip;text/plain;application/xhtml+xml
    };

    # vsCode = {
    #   name = "VSCode";
    #   generic = "Text editor";
    #   comment = "Open source text editor from Microsoft";
    #   exec = "${vscode}/bin/code";
    #   params = "%F";
    #   startupNotify = true;
    # };

    robo3t = {
      name = "Robo3T";
      generic = "Database GUI client";
      comment = "GUI for MongoDB";
      exec = "${robo3t}/bin/robo3t";
      params = "%u";
    };

    slack = {
      name = "Slack";
      generic = "Instant messaging client";
      comment = "Closed source messaging client from Slack";
      exec = "${slack}/bin/slack";
      params = "%U";
      startupNotify = true;
    };

    mpv = {
      name = "MPV";
      generic = "Multimedia player";
      comment = "Free and open source cross-platform media player";
      exec = "${mpv}/bin/mpv --player-operation-mode=pseudo-gui --";
      params = "%U";
    };
  };

  # See https://developer.gnome.org/desktop-entry-spec/
  # See https://bugs.freedesktop.org/show_bug.cgi?id=92514
  #
  # Parameters for Exec
  # %f	A single file name (including the path), even if multiple files are selected.
  # %F	A list of files. Use for apps that can open several local files at once.
  # %u	A single URL. Local files may either be passed as file: URLs or as file path.
  # %U	A list of URLs. Local files may either be passed as file: URLs or as file path.
  # %i	The Icon key of the desktop entry expanded as two arguments, first --icon and then the value of the Icon key. Should not expand to any arguments if the Icon key is empty or missing.
  # %c	The translated name of the application as listed in the appropriate Name key in the desktop entry.
  # %k	The location of the desktop file as either a URI or a local filename or empty if no location is known.
  desktopFile = {
    name,
    exec,
    params,
    generic ? "",
    comment ? "",
    wmClass ? "",
    startupNotify ? false,
    noDisplay ? false,
  }: ''
    [Desktop Entry]
    Name=${name}
    GenericName=${generic}
    Comment=${comment}
    Type=Application
    Exec=${scripts.dontFail.bin} ${exec} ${params}
    Terminal=false
    StartupNotify=${pkgs.lib.boolToString startupNotify}
    StartupWMClass=${wmClass}
    NoDisplay=${pkgs.lib.boolToString noDisplay}
  '';

  desktopFiles = builtins.mapAttrs
    (k: v: pkgs.writeText "${k}.desktop" (desktopFile ({ wmClass = k; } // v))) desktops;

in

{
  lib = { mime = { inherit desktops; }; };

  home = {
    packages = with pkgs; [
      # xdg-open will fallback to `mimetype` (provided by this package) instead
      # of `file` for determining file MIME types
      # (https://wiki.archlinux.org/index.php/default_applications)
      perlPackages.FileMimeInfo
    ];

    # See https://github.com/rycee/home-manager/pull/389
    extraProfileCommands = ''
      if [[ -d "$out/share/applications" ]] ; then
        ${pkgs.desktop-file-utils}/bin/update-desktop-database $out/share/applications
      fi
    '';
  };

  xdg = with desktopFiles; {
    configFile."mimeapps.list".text = ''
      [Default Applications]

      text/plain=${neovim.name}
      text/markdown=${neovim.name}
      application/json=${neovim.name}
      inode/directory=${neovim.name}

      application/x-cbz=${mcomix.name}
      application/x-cbr=${mcomix.name}
      application/x-cbt=${mcomix.name}
      application/x-cb7=${mcomix.name}

      text/html=${chromium.name}
      application/epub+zip=${zathura.name}
      application/pdf=${zathura.name}
      x-scheme-handler/mailto=${neomutt.name}
      x-scheme-handler/magnet=${transmission.name}

      image/gif=${mpv.name}

      audio/3gpp=${mpv.name}
      audio/3gpp2=${mpv.name}
      audio/AMR=${mpv.name}
      audio/aac=${mpv.name}
      audio/ac3=${mpv.name}
      audio/aiff=${mpv.name}
      audio/amr-wb=${mpv.name}
      audio/dv=${mpv.name}
      audio/eac3=${mpv.name}
      audio/flac=${mpv.name}
      audio/m3u=${mpv.name}
      audio/m4a=${mpv.name}
      audio/mp1=${mpv.name}
      audio/mp2=${mpv.name}
      audio/mp3=${mpv.name}
      audio/mp4=${mpv.name}
      audio/mpeg=${mpv.name}
      audio/mpeg2=${mpv.name}
      audio/mpeg3=${mpv.name}
      audio/mpegurl=${mpv.name}
      audio/mpg=${mpv.name}
      audio/musepack=${mpv.name}
      audio/ogg=${mpv.name}
      audio/opus=${mpv.name}
      audio/rn-mpeg=${mpv.name}
      audio/scpls=${mpv.name}
      audio/vnd.dolby.heaac.1=${mpv.name}
      audio/vnd.dolby.heaac.2=${mpv.name}
      audio/vnd.dts=${mpv.name}
      audio/vnd.dts.hd=${mpv.name}
      audio/vnd.rn-realaudio=${mpv.name}
      audio/vorbis=${mpv.name}
      audio/wav=${mpv.name}
      audio/webm=${mpv.name}
      audio/x-aac=${mpv.name}
      audio/x-adpcm=${mpv.name}
      audio/x-aiff=${mpv.name}
      audio/x-ape=${mpv.name}
      audio/x-m4a=${mpv.name}
      audio/x-matroska=${mpv.name}
      audio/x-mp1=${mpv.name}
      audio/x-mp2=${mpv.name}
      audio/x-mp3=${mpv.name}
      audio/x-mpegurl=${mpv.name}
      audio/x-mpg=${mpv.name}
      audio/x-ms-asf=${mpv.name}
      audio/x-ms-wma=${mpv.name}
      audio/x-musepack=${mpv.name}
      audio/x-pls=${mpv.name}
      audio/x-pn-au=${mpv.name}
      audio/x-pn-realaudio=${mpv.name}
      audio/x-pn-wav=${mpv.name}
      audio/x-pn-windows-pcm=${mpv.name}
      audio/x-realaudio=${mpv.name}
      audio/x-scpls=${mpv.name}
      audio/x-shorten=${mpv.name}
      audio/x-tta=${mpv.name}
      audio/x-vorbis=${mpv.name}
      audio/x-vorbis+ogg=${mpv.name}
      audio/x-wav=${mpv.name}
      audio/x-wavpack=${mpv.name}
      application/mxf=${mpv.name}
      application/ogg=${mpv.name}
      application/sdp=${mpv.name}
      application/smil=${mpv.name}
      application/streamingmedia=${mpv.name}
      application/vnd.apple.mpegurl=${mpv.name}
      application/vnd.ms-asf=${mpv.name}
      application/vnd.rn-realmedia=${mpv.name}
      application/vnd.rn-realmedia-vbr=${mpv.name}
      application/x-cue=${mpv.name}
      application/x-extension-m4a=${mpv.name}
      application/x-extension-mp4=${mpv.name}
      application/x-matroska=${mpv.name}
      application/x-mpegurl=${mpv.name}
      application/x-ogg=${mpv.name}
      application/x-ogm=${mpv.name}
      application/x-ogm-audio=${mpv.name}
      application/x-ogm-video=${mpv.name}
      application/x-shorten=${mpv.name}
      application/x-smil=${mpv.name}
      application/x-streamingmedia=${mpv.name}
      video/3gp=${mpv.name}
      video/3gpp=${mpv.name}
      video/3gpp2=${mpv.name}
      video/avi=${mpv.name}
      video/divx=${mpv.name}
      video/dv=${mpv.name}
      video/fli=${mpv.name}
      video/flv=${mpv.name}
      video/mkv=${mpv.name}
      video/mp2t=${mpv.name}
      video/mp4=${mpv.name}
      video/mp4v-es=${mpv.name}
      video/mpeg=${mpv.name}
      video/msvideo=${mpv.name}
      video/ogg=${mpv.name}
      video/quicktime=${mpv.name}
      video/vnd.divx=${mpv.name}
      video/vnd.mpegurl=${mpv.name}
      video/vnd.rn-realvideo=${mpv.name}
      video/webm=${mpv.name}
      video/x-avi=${mpv.name}
      video/x-flc=${mpv.name}
      video/x-flic=${mpv.name}
      video/x-flv=${mpv.name}
      video/x-m4v=${mpv.name}
      video/x-matroska=${mpv.name}
      video/x-mpeg2=${mpv.name}
      video/x-mpeg3=${mpv.name}
      video/x-ms-afs=${mpv.name}
      video/x-ms-asf=${mpv.name}
      video/x-ms-wmv=${mpv.name}
      video/x-ms-wmx=${mpv.name}
      video/x-ms-wvxvideo=${mpv.name}
      video/x-msvideo=${mpv.name}
      video/x-ogm=${mpv.name}
      video/x-ogm+ogg=${mpv.name}
      video/x-theora=${mpv.name}
      video/x-theora+ogg=${mpv.name}
    '';

    dataFile =
      let
        makePair = v: {
          name = "applications/${v.name}";
          value = { source = "${v}"; };
        };
      in
      builtins.listToAttrs (map makePair (builtins.attrValues desktopFiles));
  };
}
