{ config, pkgs, ... }:

{
  imports = [
    ../../lib/common.nix
    ../../lib/common.linux.nix
    ../../lib/desktops/gnome-i3.nix
  ];
}

