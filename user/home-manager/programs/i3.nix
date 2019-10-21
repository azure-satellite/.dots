{ config, pkgs, ... }:

let

  scripts = config.lib.functions.writeShellScriptsBin (with pkgs; {
    takeScreenshot = ''
      set -e
      PATH="${config.lib.vars.home}/Pictures/screenshots/$(date +%s).png"
      ${coreutils}/bin/mkdir -p $(${coreutils}/bin/dirname "$PATH")
      ${maim}/bin/maim $1 -b 4 "$PATH"
      ${config.lib.aliases.cp-png} "$PATH"
      ${libnotify}/bin/notify-send -a Maim "Screenshot saved" "<u>$PATH</u>"
    '';
  });

  mkModeBindings = name: mode:
    let bindings = builtins.mapAttrs (k: v: v + "; mode default") mode; in
    { q = "mode default"; Escape = "mode default"; } // bindings;

  keybindings = {
    # Container switching/moving
    "Mod1 + j"             = "focus down";
    "Mod1 + k"             = "focus up";
    "Mod1 + l"             = "focus right";
    "Mod1 + h"             = "focus left";
    "Mod1 + Shift + j"     = "move down";
    "Mod1 + Shift + k"     = "move up";
    "Mod1 + Shift + l"     = "move right";
    "Mod1 + Shift + h"     = "move left";

    # Workspace switching/moving
    "Mod1 + 1"         = "workspace 1";
    "Mod1 + 2"         = "workspace 2";
    "Mod1 + 3"         = "workspace 3";
    "Mod1 + 4"         = "workspace 4";
    "Mod1 + 5"         = "workspace 5";
    "Mod1 + 6"         = "workspace 6";
    "Mod1 + 7"         = "workspace 7";
    "Mod1 + 8"         = "workspace 8";
    "Mod1 + 9"         = "workspace 9";
    "Mod1 + Shift + 1" = "move container to workspace 1";
    "Mod1 + Shift + 2" = "move container to workspace 2";
    "Mod1 + Shift + 3" = "move container to workspace 3";
    "Mod1 + Shift + 4" = "move container to workspace 4";
    "Mod1 + Shift + 5" = "move container to workspace 5";
    "Mod1 + Shift + 6" = "move container to workspace 6";
    "Mod1 + Shift + 7" = "move container to workspace 7";
    "Mod1 + Shift + 8" = "move container to workspace 8";
    "Mod1 + Shift + 9" = "move container to workspace 9";
    "Mod1+Tab"         = "workspace back_and_forth";

    # Window commands
    "Mod1+p"           = "focus parent";
    "Mod1+c"           = "focus child";
    "Mod1+m"           = "split h";
    "Mod1+n"           = "split v";
    "Mod1+e"           = "layout default";
    "Mod1+s"           = "layout stacking";
    "Mod1+t"           = "layout tabbed";
    "Mod1+f"           = "floating toggle";
    "Mod1+o"           = "fullscreen toggle";
    "Mod1+q"           = "kill";
    "Mod1+Down"        = "resize shrink height 10 px or 10 ppt";
    "Mod1+Up"          = "resize grow height 10 px or 10 ppt";
    "Mod1+Left"        = "resize shrink width 10 px or 10 ppt";
    "Mod1+Right"       = "resize grow width 10 px or 10 ppt";
    "Mod1+apostrophe"  = "focus mode_toggle";

    # Reloading
    "Mod1+Shift+c"         = "reload";
    "Mod1+Shift+r"         = "restart";
    "Mod1+Shift+q"         = "exit";
    "Mod1+Shift+BackSpace" = "exec --no-startup-id sudo systemctl restart display-manager.service";

    # External commands
    "XF86AudioRaiseVolume" = "exec amixer set Master 5%+";
    "XF86AudioLowerVolume" = "exec amixer set Master 5%-";
    "XF86AudioMute"        = "exec amixer set Master toggle";
    "Print"                = ''--release exec ${scripts.takeScreenshot.bin}'';
    "Shift+Print"          = ''--release exec ${scripts.takeScreenshot.bin} -s'';
    "Mod1+Return"          = "exec i3-sensible-terminal";
    "Mod1+space"           = "exec rofi -show drun";
    "Mod1+Shift+m"         = ''exec st -c 'home-manager-switch' fish -c 'home-manager switch -b bak || read -P "Continue..."' '';
  };

in

{
  imports = [
    ./dunst.nix
    ./polybar.nix
    ./rofi.nix
  ];

  home = {
    packages = with pkgs; [
      maim
      xclip
    ];
  };

  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = {
      inherit keybindings;
      modes = builtins.mapAttrs mkModeBindings {};
      focus.followMouse = false;
      fonts = with config.lib; [
        (functions.fontConfigString fonts.ui)
      ];
      colors = with config.lib.colors; rec {
        focused = rec {
          text = theme.primary.bg;
          background = theme.text.fg;
          border = theme.base5;
          childBorder = border;
          indicator = border;
        };
        unfocused = rec {
          text = theme.text.fg;
          background = theme.primary.bg;
          border = theme.base2;
          childBorder = border;
          indicator = border;
        };
        # For example: Tab color when it has splits
        focusedInactive = focused // {
          childBorder = unfocused.childBorder;
          indicator = unfocused.indicator;
        };
      };
    };
    extraConfig = ''
      default_border pixel 1
      title_align center
      smart_gaps on
      smart_borders on

      gaps inner 11
      gaps outer -4

      for_window [class=home-manager-switch] floating enable

      for_window [window_role=GtkFileChooserDialog] floating enable
      for_window [window_role=GtkFileChooserDialog] resize set 2048 1536
      for_window [window_role=GtkFileChooserDialog] move position center

      for_window [window_role=pop-up] floating enable
      for_window [window_role=pop-up] resize set 2048 1536 
      for_window [window_role=pop-up] move position center
    '';
  };
}
