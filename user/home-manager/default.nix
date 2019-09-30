{ config, pkgs, ... }:

with pkgs;

{
  imports = [
    ./xkb
    ./misc.nix
    ./fonts.nix
    ./colors.nix
    ./email.nix
    ./programs/direnv.nix
    ./programs/fish
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/i3.nix
    ./programs/node.nix
    ./programs/nvim.nix
    ./programs/neomutt
  ];

  manual.html.enable = true;

  home = {
    packages = [
      # Terminal
      (neovim.override { viAlias = true; vimAlias = true; })
      ffmpeg
      libnotify
      pandoc
      pass
      python
      python37
      ripgrep
      st
      tig
      tree
      universal-ctags
      xdotool
      youtube-dl
      unrar

      # GUI
      brave
      calibre
      font-manager
      imagemagick
      mcomix
      peek
      robo3t
      slack
      transmission-gtk
      vscode

      # Appearance
      # adapta-gtk-theme
      mojave-gtk-theme
      # sierra-gtk-theme
      # numix-gtk-theme
      # paper-gtk-theme
      # pantheon.elementary-gtk-theme
      qgnomeplatform
      # arc-icon-theme
      # numix-icon-theme
      # numix-icon-theme-square
      # numix-icon-theme-circle
      # pantheon.elementary-icon-theme
      # elementary-xfce-icon-theme
      # tango-icon-theme
      papirus-icon-theme
    ];

    sessionVariables = config.lib.sessionVariables;
  };

  xdg.enable = true;

  xsession = {
    enable = true;

    pointerCursor = {
      package = vanilla-dmz;
      name = "Vanilla-DMZ";
      size = 64;
    };

    initExtra = ''
      [ -f ${config.home.homeDirectory}/.fehbg ] && ${config.home.homeDirectory}/.fehbg &
      '';

    # Written to ~/.xprofile
    # We need to export variables here as opposed to lib.sessionVariables
    # because we don't want them quoted
    profileExtra = ''
      mkdir -p ${config.home.homeDirectory}/.local/share/tig
      export LESS_TERMCAP_mb=$'\e[0;1;31m'
      export LESS_TERMCAP_md=$'\e[0;1;31m'
      export LESS_TERMCAP_me=$'\e[0;39m'
      export LESS_TERMCAP_se=$'\e[0;39m'
      export LESS_TERMCAP_so=$'\e[0;1;30;43m'
      export LESS_TERMCAP_ue=$'\e[0;39m'
      export LESS_TERMCAP_us=$'\e[0;1;32m'
    '';
  };

  gtk = with config.lib; {
    # Cursors are set in xsession
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

  programs = {
    home-manager = {
      enable = true;
      path = "${config.lib.paths.userSrc}/home-manager";
    };

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

    bash = {
      enable = true;
      historyControl = [ "erasedups" "ignorespace" ];
      historyFile = "${config.home.homeDirectory}/.cache/bash_history";
      historyIgnore = [ "\"&" "[ ]*" "exit" "ls" "bg" "fg" "env" "history" "clear\"" ];
      shellAliases = config.lib.aliases;
      shellOptions = [
        "checkwinsize" "globstar" "globasciiranges" "direxpand"
        "dirspell" "histappend" "cmdhist" "autocd" "cdspell"
      ];
    };
  };

  services = {
    # compton = {
    #   enable = true;
    #   shadow = true;
    # };
    gpg-agent = let ttl = 60480000; in {
      enable = true;
      enableSshSupport = true;
      defaultCacheTtl = ttl;
      defaultCacheTtlSsh = ttl;
      maxCacheTtl = ttl;
      maxCacheTtlSsh = ttl;
    };
  };

  systemd.user.startServices = true;

  xresources.properties = with config.lib.colors.theme; {
    "*.alpha"        = "1.0";
    "st.termname"    = "st-256color";
    "st.borderpx"    = 0;
    "st.font"        = with config.lib; functions.xftString (fonts.mono // { size = fonts.mono.size * 4; });
    "st.color0"      = black;
    "st.color1"      = red;
    "st.color2"      = green;
    "st.color3"      = yellow;
    "st.color4"      = blue;
    "st.color5"      = magenta;
    "st.color6"      = cyan;
    "st.color7"      = white;
    "st.color8"      = base0;
    "st.color9"      = base1;
    "st.color10"     = base2;
    "st.color11"     = base3;
    "st.color12"     = base4;
    "st.color13"     = base5;
    "st.color14"     = base6;
    "st.color15"     = base7;
    "st.cursorColor" = cursor.bg;
    "st.foreground"  = default.fg;
    "st.background"  = default.bg;
  };
}

