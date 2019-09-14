{ config, pkgs, ... }:

{
  # See https://nixos.wiki/wiki/Accelerated_Video_Playback
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  hardware = {
    nvidiaOptimus.disable = true;

    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        vaapiIntel
        intel-media-driver
      ];
    };
  };

  fonts = {
    fontconfig = { dpi = 282; };
  };

  environment = {
    sessionVariables = {
      # See https://nixos.wiki/wiki/Accelerated_Video_Playback
      LIBVA_DRIVER_NAME = "iHD";
    };
  };

  services = {
    dbus.packages = [ pkgs.gnome3.dconf ];

    xserver = {
      enable = true;

      dpi = 282;

      # The "intel" driver is less stable than the modesetting driver but it can
      # eliminate tearing with the `Option "TearFree" "true"` setting (see
      # https://wiki.archlinux.org/index.php/intel_graphics#Tearing). Such
      # configuration has no effect when the "modesetting" driver is used,
      # however there's a bug to add an equivalent to it
      # (https://gitlab.freedesktop.org/xorg/xserver/issues/244). In the
      # meantime, use compton.
      videoDrivers = [ "modesetting" ];

      libinput = {
        enable = true;
        accelSpeed = "0.7";
        disableWhileTyping = true;
        clickMethod = "clickfinger";
        additionalOptions = ''
          Option "TappingDrag" "false"
        '';
      };

      autoRepeatDelay = 250;

      autoRepeatInterval = 35;

      xkbOptions = "ctrl:swapcaps";

      displayManager.lightdm = {
        enable = true;
        greeter.enable = false;
        autoLogin = {
          enable = true;
          user = config.users.users.berserk.name;
        };
      };

      windowManager = {
        default = "i3";
        i3.enable = true;
      };

      desktopManager = {
        default = "none";
        xterm.enable = false;
      };
    };

    xbanish.enable = true;
  };

  programs = {
    dconf.enable = true;
  };
}
