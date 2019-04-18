{ config, pkgs, ... }:

with pkgs;

{
  imports = [
    ./xkb
    ./lib.nix
    ./mime.nix
    ./email.nix
    ./programs/git.nix
    ./programs/node.nix
    ./programs/i3.nix
    ./programs/fzf.nix
    ./programs/direnv.nix
    ./programs/fish
  ];

  manual.html.enable = true;

  home = {
    packages = [
      # Terminal
      iosevka
      inotify-tools # required by i3blocks mail script
      iw # required by i3blocks networking script
      libnotify
      mpv
      pass
      python
      python37
      ripgrep
      st
      tig
      tree
      universal-ctags
      (neovim.override { viAlias = true; vimAlias = true; })

      # GUI
      calibre
      imagemagick
      slack
      transmission-gtk
      firefox
      chromium
      vscode
      mcomix
      gtk3
    ];

    sessionVariables = config.lib.sessionVariables;
  };

  xdg = {
    enable = true;

    configFile = {
      "mpv/mpv.conf".text = ''
        # Enable hardware acceleration. See
        # https://nixos.wiki/wiki/Accelerated_Video_Playback
        vo=gpu
        hwdec=vaapi
        hwdec-codecs=all
        # https://github.com/mpv-player/mpv/issues/4241
        ytdl-format=bestvideo[height<=?720][fps<=?30][vcodec!=?vp9]+bestaudio/best
        # Prevent harmless warnings/errors when using hardware decoding
        msg-level=vo=fatal
      '';
    };
  };

  xsession = {
    enable = true;

    pointerCursor = {
      package = vanilla-dmz;
      name = "Vanilla-DMZ";
      size = 64;
    };

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

  gtk = {
    # Cursors are set in xsession
    enable = true;
    # NOTE: The icon/theme name are not arbitrary. Check under
    # ~/.nix-profile/share/{icons,themes} for possible names
    iconTheme = {
      name = "deepin";
      package = deepin.deepin-icon-theme;
    };
    theme = {
      name = "deepin";
      package = deepin.deepin-gtk-theme;
    };
    font = {
      name = "UbuntuCondensed Nerd Font";
    };
    gtk3.extraConfig = {
      "gtk-enable-animations" = false;
      "gtk-enable-event-sounds" = false;
      "gtk-enable-input-feedback-sounds" = false;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
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

  xresources.properties =
    with config.lib.colors.theme;
    with config.lib.colors.palette; {
      # TODO: Add another entry in terminfo with a name of "st"
      # This is the only entry in terminfo that works.
      "st.termname" = "st-256color";
      "st.borderpx" = 0;
      "st.font" = "monospace:pixelsize=36";
      "st.color0" = black.color;
      "st.color1" = red.color;
      "st.color2" = green.color;
      "st.color3" = yellow.color;
      "st.color4" = blue.color;
      "st.color5" = magenta.color;
      "st.color6" = cyan.color;
      "st.color7" = white.color;
      "st.color8" = base0.color;
      "st.color9" = base1.color;
      "st.color10" = base2.color;
      "st.color11" = base3.color;
      "st.color12" = base4.color;
      "st.color13" = base5.color;
      "st.color14" = base6.color;
      "st.color15" = base7.color;
      "st.cursorColor" = brGreen.color;
      "st.foreground" = fg.color;
      "st.background" = bg.color;
    };
}

