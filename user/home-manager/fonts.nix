{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    iosevka
  ];

  fonts.fontconfig.enable = true;

  lib = {
    functions = {
      fontConfigString = font: with pkgs.lib.strings;
        "${font.name} ${concatStringsSep " " font.attrs} ${toString font.size}";

      xftString = font: with pkgs.lib.strings;
        "${font.name}:${concatStringsSep ":" font.attrs}:pixelsize=${toString font.size}";
    };

    fonts = {
      mono = { name = "Iosevka"; attrs = []; size = 9; };
      sans = { name = "SF Pro Text"; attrs = ["medium"]; size = 9; };
      serif = { name = "SF Pro Text"; attrs = ["medium"]; size = 9; };
      ui = { name = "SF Pro Rounded"; attrs = ["medium"]; size = 9; };
    };
  };
}
