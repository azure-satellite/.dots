{ config, pkgs, ... }:

with pkgs;

{
  programs.rofi = {
    enable = true;
  };
}

