{ config, pkgs, ... }:

with pkgs;

{
  imports = [
    ../programs/i3.nix
  ];

  home.packages = [
    libnotify
    xdotool
    font-manager
    peek
    # Appearance
    # adapta-gtk-theme
    mojave-gtk-theme
    # sierra-gtk-theme
    # numix-gtk-theme
    # paper-gtk-theme
    # pantheon.elementary-gtk-theme
    # qgnomeplatform
    # arc-icon-theme
    # numix-icon-theme
    # numix-icon-theme-square
    # numix-icon-theme-circle
    # pantheon.elementary-icon-theme
    # elementary-xfce-icon-theme
    # tango-icon-theme
    papirus-icon-theme
  ];

  home.sessionVariables = with config.lib.vars; {
    # HiDPI stuff
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    GTK2_RC_FILES = "${home}/.config/gtk-2.0/gtkrc";
    # Big discussion at Nixpkgs. Can't remember why it's here but it fixes shit.
    GDK_PIXBUF_MODULE_FILE = "${librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache";
  };

  programs.feh.enable = true;

  programs.zathura = {
    enable = true;
    extraConfig = ''
      map d scroll half-down
      map u scroll half-up
    '';
  };

  programs.mpv = {
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

  xdg.mimeApps.defaultApplications = with config.lib.mimetypes; with config.lib.functions;
    (defaultMimeApp "mpv.desktop" video) //
    (defaultMimeApp "mpv.desktop" audio) //
    (defaultMimeApp "feh.desktop" image) //
    {
      "application/pdf" = "org.pwmt.zathura.desktop";
      "x-scheme-handler/mailto" = "neomutt.desktop";
    };

  xsession = {
    enable = true;
    pointerCursor = {
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ";
      size = 64;
    };
    # Written to ~/.xprofile
    # We need to export variables here as opposed to lib.sessionVariables
    # because we don't want them quoted
    profileExtra = ''
      [ -f ${config.lib.vars.home}/.fehbg ] && ${config.lib.vars.home}/.fehbg &
      export LESS_TERMCAP_mb=$'\e[0;1;31m'
      export LESS_TERMCAP_md=$'\e[0;1;31m'
      export LESS_TERMCAP_me=$'\e[0;39m'
      export LESS_TERMCAP_se=$'\e[0;39m'
      export LESS_TERMCAP_so=$'\e[0;1;30;43m'
      export LESS_TERMCAP_ue=$'\e[0;39m'
      export LESS_TERMCAP_us=$'\e[0;1;32m'
    '';
  };

  # Cursors are set in xsession
  gtk = with config.lib; {
    enable = true;
    font.name = functions.fontConfigString fonts.serif;
    theme.name = "Mojave-light-solid";
    # NOTE: The icon/theme name are not arbitrary. Check under
    # ~/.nix-profile/share/{icons,themes} for possible names
    iconTheme.name = "Papirus-Light";
    gtk3.extraConfig = {
      "gtk-enable-animations" = false;
      "gtk-enable-event-sounds" = false;
      "gtk-enable-input-feedback-sounds" = false;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
  };

  services.compton = {
    enable = false;
    shadow = true;
  };

  services.gpg-agent = let ttl = 60480000; in {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = ttl;
    defaultCacheTtlSsh = ttl;
    maxCacheTtl = ttl;
    maxCacheTtlSsh = ttl;
  };
}
