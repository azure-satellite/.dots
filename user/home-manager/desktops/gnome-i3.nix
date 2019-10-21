{ config, pkgs, ... }:

{
  imports = [
    ../programs/i3.nix
  ];

  home.packages = with pkgs; [
    gnome3.gnome-flashback 
  ];
}
