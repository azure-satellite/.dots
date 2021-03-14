{ config, pkgs, lib, ... }:

{
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Papirus-Light";
      package = pkgs.papirus-icon-theme;
    };
    settings = lib.recursiveUpdate {
      global = {
        # {width}][x{height}][+/-{x}[+/-{y}]]
        geometry = "1000x10-10+80";
        padding = 10;
        horizontal_padding = 20;
        frame_width = 4;
        separator_height = 4;
        sort = false;
        font = with config.lib;
          functions.fontConfigString (fonts.ui // { size = fonts.ui.size + 0.5; });
        markup = "full";
        format = "<b>%a</b>: <span foreground='#333'>%s\\n%b</span>";
        show_age_threshold = 60;
        word_wrap = true;
        max_icon_size = 64;
        dmenu = "${pkgs.dmenu}/bin/dmenu -p dunst";
        browser = config.home.sessionVariables.BROWSER;
        corner_radius = 5;
        mouse_left_click = "do_action";
      };
      shortcuts = {
        close = "ctrl+space";
        close_all = "ctrl+shift+space";
        history = "ctrl+grave";
        context = "ctrl+shift+period";
      };
      urgency_low = rec {
        timeout = 0;
      };
      urgency_normal = rec {
        timeout = 0;
      };
      urgency_critical = rec {
        timeout = 0;
      };
    } config.lib.colors.dunst;
  };
}
