# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# - override "fixes" arguments of a function
# - overrideAttrs replaces attributes of a derivation built with
# stdenv.mkDerivation

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./graphical.nix
      ./networking.nix
    ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09";

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_latest;

    kernelParams = [
      # https://wiki.archlinux.org/index.php/Dell_XPS_15_9570
      "mem_sleep_default=deep"

      # https://wiki.archlinux.org/index.php/Dell_XPS_15_9560#Disable_discrete_GPU
      "acpi_rev_override=1"

      # https://wiki.archlinux.org/index.php/Improving_performance#Watchdogs
      "nowatchdog"
    ];

    blacklistedKernelModules = [
      # Webcam
      "uvcvideo"

      "iTCO_wdt"
      "wacom"
    ];

    consoleLogLevel = 3;

    earlyVconsoleSetup = true;

    cleanTmpDir = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  hardware = {
    enableAllFirmware = true;

    bluetooth.enable = true;

    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudio.override {
        bluetoothSupport = true;
      };
    };
  };

  time.timeZone = "America/New_York";

  users.users = {
    berserk = {
      shell = pkgs.fish;
      isNormalUser = true;
      extraGroups = [ "wheel" "video" "audio" "docker" "sway" ];
      uid = 1000;
    };
  };

  nix.trustedUsers = [ config.users.users.berserk.name ];

  # https://stackoverflow.com/questions/47952567/how-can-i3-config-execute-sudo-commands
  security.sudo.extraConfig = ''
    ${config.users.users.berserk.name} ALL=NOPASSWD: ALL
  '';

  i18n = {
    consoleFont = "latarcyrheb-sun32";
  };

  environment = {
    systemPackages = with pkgs; [
      bluez-tools
      exfat
      file
      gcc
      git
      gnumake
      htop
      killall
      lshw
      lsof
      manpages
      pciutils
      unzip
      usbutils
      wget
    ];
  };

  programs = {
    light.enable = true;
  };

  powerManagement.powertop.enable = true;

  services = {
    upower.enable = true;

    fwupd.enable = true;

    journald.extraConfig = "SystemMaxUse=100M";

    logind = {
      extraConfig = ''
        HandlePowerKey=suspend
        HandleSuspendKey=ignore
      '';
    };

    actkbd = {
      enable = true;

      # Figure out the keys with (for example) "sudo actkbd -n -s -d /dev/input/event8"
      # https://nixos.wiki/wiki/Actkbd
      bindings = with pkgs; [
        { keys = [ 224 ]; events = [ "key" "rep" ]; command = "${pkgs.light}/bin/light -U 3"; }
        { keys = [ 225 ]; events = [ "key" "rep" ]; command = "${pkgs.light}/bin/light -A 3"; }
      ];
    };
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };
}
