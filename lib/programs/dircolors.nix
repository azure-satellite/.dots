{ config, pkgs, ... }:

{
  programs.dircolors = {
    enable = true;
    settings = {
      # TODO: Generate this programmatically based off a dircolors mapping
      #
      # Attribute codes:
      # 0=none 1=bold 3=italic 4=underscore 5=blink 7=reverse 8=concealed 9=strikethrough
      #
      # Text color codes:
      # 30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
      #
      # Background color codes:
      # 40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white
      # DIR = "0;1;31";
      # LINK = "0;1;32";
    };
  };
}

