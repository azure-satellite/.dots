{ config, pkgs, ... }:

with pkgs;

let

in

{
  services.polybar = {
    enable = false;
    package = pkgs.polybar.override {
      i3GapsSupport = true;
      pulseSupport = true;
    };
    script = "polybar topbar &";
  };
}
