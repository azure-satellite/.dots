{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    settings = with config.lib.fonts; with config.home; {
      active_border_color = "none";
      active_tab_font_style = "normal";
      clear_all_shortcuts = "yes";
      close_on_child_death = "yes";
      copy_on_select = "yes";
      cursor_blink_interval = 0;
      disable_ligatures = "always";
      enabled_layouts = "splits,stack";
      font_family = mono.name;
      font_size = 17;
      inactive_tab_font_style = "normal";
      input_delay = 10;
      repaint_delay = 50;
      kitty_mod = "cmd";
      macos_quit_when_last_window_closed = "yes";
      macos_thicken_font = "0.75";
      placement_strategy = "top-left";
      rectangle_select_modifiers = "cmd";
      shell = "${profileDirectory}/bin/fish --login";
      strip_trailing_spaces = "smart";
      tab_bar_min_tabs = 1;
      tab_bar_style = "separator";
      tab_separator = "│";
      tab_title_template = "{title}";
      url_style = "curly";
    } // config.lib.colors.kitty;
    keybindings = {
      "cmd+0"       = "change_font_size all 0";
      "cmd+1"       = "goto_tab 1";
      "cmd+2"       = "goto_tab 2";
      "cmd+3"       = "goto_tab 3";
      "cmd+4"       = "goto_tab 4";
      "cmd+5"       = "goto_tab 5";
      "cmd+6"       = "goto_tab 6";
      "cmd+7"       = "goto_tab 7";
      "cmd+8"       = "goto_tab 8";
      "cmd+9"       = "goto_tab 9";
      "cmd+["       = "previous_tab";
      "cmd+]"       = "next_tab";
      "cmd+c"       = "copy_to_clipboard";
      "cmd+down"    = "resize_window shorter 5";
      "cmd+equal"   = "change_font_size all +1.0";
      "cmd+h"       = "neighboring_window left";
      "cmd+j"       = "neighboring_window down";
      "cmd+k"       = "neighboring_window up";
      "cmd+l"       = "neighboring_window right";
      "cmd+left"    = "resize_window narrower 5";
      "cmd+m"       = "launch --cwd=current --location=vsplit";
      "cmd+minus"   = "change_font_size all -1.0";
      "cmd+n"       = "launch --cwd=current --location=hsplit";
      "cmd+o"       = "next_layout";
      "cmd+right"   = "resize_window wider 5";
      "cmd+shift+[" = "move_tab_backward";
      "cmd+shift+]" = "move_tab_forward";
      "cmd+shift+h" = "move_window left";
      "cmd+shift+j" = "move_window down";
      "cmd+shift+k" = "move_window up";
      "cmd+shift+l" = "move_window right";
      "cmd+t"       = "new_tab_with_cwd";
      "cmd+up"      = "resize_window taller 5";
      "cmd+v"       = "paste_from_clipboard";
      "cmd+w"       = "close_tab";
      "cmd+x"       = "close_window";
    };
  };
}
