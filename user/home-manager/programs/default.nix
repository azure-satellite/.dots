{ config, pkgs, ... }:

let

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

makeDefault = mimelist: desktop:
  builtins.listToAttrs (builtins.map (mime: { name = mime; value = desktop; }) mimelist);

in

{
  imports = [
    ./nvim.nix
    ./neomutt
  ];

  home.packages = with pkgs; [
    brave
    calibre
    mcomix
    transmission-gtk
    vscode
  ];

  xsession.initExtra = ''
    [ -f ${config.home.homeDirectory}/.fehbg ] && ${config.home.homeDirectory}/.fehbg &
  '';

  programs = {
    feh.enable = true;

    zathura = {
      enable = true;
      extraConfig = ''
        map d scroll half-down
        map u scroll half-up
      '';
    };

    mpv = {
      enable = true;
      config = {
        # Enable hardware acceleration. See
        # https://nixos.wiki/wiki/Accelerated_Video_Playback
        vo = "gpu";
        hwdec = "vaapi";
        hwdec-codecs = "all";
        # https://github.com/mpv-player/mpv/issues/4241
        ytdl-format = "bestvideo[height<=?720][fps<=?30][vcodec!=?vp9]+bestaudio/best";
        # Prevent harmless warnings/errors when using hardware decoding
        msg-level = "vo=fatal";
      };
    };
  };

  lib.sessionVariables = with config.lib.paths; rec {
    # Default applications
    # The whole userBin thing is so these variables point to the correct one
    # if we build a different version
    BROWSER = "${userBin}/brave";
    TERMINAL = "${userBin}/st";
    EDITOR = "${userBin}/nvim";
    VISUAL = "${EDITOR}";
    MAILER = "${userBin}/neomutt";
    PAGER = "${systemBin}/less";
    MANPAGER = "${systemBin}/less -s -M";
  };

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

  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      (makeDefault video "mpv.desktop") //
      (makeDefault audio "mpv.desktop") //
      (makeDefault image "feh.desktop") //
      (makeDefault text "nvim.desktop") //
      (makeDefault xscheme "brave-browser.desktop") //
      {
        "x-scheme-handler/mailto" = "neomutt.desktop";
        "application/epub+zip" = "calibre-ebook-viewer.desktop";
        "application/pdf" = "org.pwmt.zathura.desktop";
      };
  };
}
