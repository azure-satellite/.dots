{ config, pkgs, ... }:

with pkgs;

{
  services.polybar = {
    enable = false;
    package = pkgs.polybar.override {
      i3GapsSupport = true;
      pulseSupport = true;
    };
    config = {
      "bar/top" = {
        monitor = "\''${env:MONITOR:eDP1}";
        width = "100%";
        height = "3%";
        radius = 0;
        modules-center = "date";
      };
    };
    script = "polybar topbar &";
  };
}
