{ config, pkgs, ... }:

let

  dmenuWindowClass = "dmenu-window";

  windowTitleToClass = v: with builtins;
    concatStringsSep "-" (map pkgs.lib.toLower (filter isString (split "[[:space:]]+" v)));

  scripts = config.lib.functions.writeShellScriptsBin (with pkgs; {
    takeScreenshot = ''
      set -e
      PATH="${config.home.homeDirectory}/Pictures/screenshots/$(date +%s).png"
      ${coreutils}/bin/mkdir -p $(${coreutils}/bin/dirname "$PATH")
      ${maim}/bin/maim $1 -b 4 "$PATH"
      ${config.lib.aliases.cp-png} "$PATH"
      ${libnotify}/bin/notify-send "Maim" "Screenshot saved to '$PATH'"
    '';

    homeManagerSwitch = ''
      home-manager switch || read -p "Continue..."
    '';

    dmenu = ''
      set -e
      i3-msg -t subscribe -m '["window", "workspace"]' | while read line; do
        [[ "$line" == '{"change":"focus"'* ]] && i3-msg [class=${dmenuWindowClass}*] kill
      done &
      $@ || true
    '';

    # TODO:
    # - Order by MRU
    # - Send stdout/stderr to logger
    # - Notify on failed command
    # - ANSI color escape sequences for fzf
    runDesktopFile = with builtins;
      let
        reduceDesktops = fn: concatStringsSep "\n" (map fn (attrValues config.lib.mime.desktops));
        dmenuLine = v: "${v.name} (${v.generic})";
        caseLine = v: ''"${v.name}"*) (${coreutils}/bin/nohup ${v.exec} & disown);;'';
        fzfOpts = ''--margin=4,8,0,10 --ansi --exact --delimiter="(" --nth=1'';
      in
      ''
        openit() {
          read name
          case $name in
            ${reduceDesktops caseLine}
            *) exit 0
          esac
        }
        echo "${reduceDesktops dmenuLine}" | ${fzf}/bin/fzf ${fzfOpts} | openit
      '';

    copyPassword = ''
      ${findutils}/bin/find -type f -name '*.gpg' -printf '%P\n' | ${fzf}/bin/fzf ${fzfOpts} | copyit
    '';
  });

  dmenuBinding = { script, title }:
    ''exec --no-startup-id st -c "${dmenuWindowClass}-${windowTitleToClass title}" -t "${title}" ${scripts.dmenu.bin} ${script.bin}'';

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
    "Mod1 + 1"             = "workspace 1";
    "Mod1 + 2"             = "workspace 2";
    "Mod1 + 3"             = "workspace 3";
    "Mod1 + 4"             = "workspace 4";
    "Mod1 + 5"             = "workspace 5";
    "Mod1 + 6"             = "workspace 6";
    "Mod1 + 7"             = "workspace 7";
    "Mod1 + 8"             = "workspace 8";
    "Mod1 + 9"             = "workspace 9";
    "Mod1 + Shift + 1"     = "move container to workspace 1";
    "Mod1 + Shift + 2"     = "move container to workspace 2";
    "Mod1 + Shift + 3"     = "move container to workspace 3";
    "Mod1 + Shift + 4"     = "move container to workspace 4";
    "Mod1 + Shift + 5"     = "move container to workspace 5";
    "Mod1 + Shift + 6"     = "move container to workspace 6";
    "Mod1 + Shift + 7"     = "move container to workspace 7";
    "Mod1 + Shift + 8"     = "move container to workspace 8";
    "Mod1 + Shift + 9"     = "move container to workspace 9";

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
    "Mod1+apostrophe"  = "focus mode_toggle";
    "Mod1+Down"        = "resize shrink height 10 px or 10 ppt";
    "Mod1+Up"          = "resize grow height 10 px or 10 ppt";
    "Mod1+Left"        = "resize shrink width 10 px or 10 ppt";
    "Mod1+Right"       = "resize grow width 10 px or 10 ppt";
    "Mod1+Tab"         = "workspace back_and_forth";

    # Reloading
    "Mod1+Shift+c"         = "reload";
    "Mod1+Shift+r"         = "restart";
    "Mod1+Shift+q"         = "exit";
    "Mod1+BackSpace" = "exec --no-startup-id sudo systemctl restart display-manager.service";

    # External commands
    "XF86AudioRaiseVolume" = "exec amixer set Master 5%+";
    "XF86AudioLowerVolume" = "exec amixer set Master 5%-";
    "XF86AudioMute"        = "exec amixer set Master toggle";
    "Print"                = ''--release exec ${scripts.takeScreenshot.bin}'';
    "Shift+Print"          = ''--release exec ${scripts.takeScreenshot.bin} -s'';
    "Mod1+Return"          = "exec i3-sensible-terminal";
    "Mod1+space"           = "mode dmenu";
    "Mod1+Shift+m"         = ''exec st -c 'home-manager-switch' fish -c 'home-manager switch || read -P "Continue..."' '';
  };

in

{
  home = {
    packages = with pkgs; [
      dunst
      hicolor-icon-theme
      i3blocks
      maim
      xclip
    ];
  };

  xsession.windowManager.i3 = {
    enable = true;

    config = rec {
      fonts = [ "UbuntuCondensed Nerd Font 10" ];

      colors = with config.lib.colors.palette; rec {
        focused = rec {
          background = base6.color;
          border = background;
          childBorder = background;
          indicator = childBorder;
          text = black.color;
        };

        unfocused = rec {
          background = base3.color;
          border = base4.color;
          childBorder = background;
          indicator = childBorder;
          text = base6.color;
        };

        # For example: Tab color when it has splits
        focusedInactive = focused // {
          childBorder = unfocused.childBorder;
          indicator = unfocused.indicator;
        };
      };

      bars = [
        {
          inherit fonts;
          position = "top";
          trayOutput = "none";
          statusCommand = "SCRIPTS=${config.home.homeDirectory}/.config/i3blocks ${pkgs.i3blocks}/bin/i3blocks";
          colors =
            with config.lib.colors.palette;
            with config.lib.colors.theme;
            {
              background = bg.color;
              statusline = white.color;
              separator = base4.color;
            };
        }
      ];

      modes = builtins.mapAttrs mkModeBindings {
        dmenu = {
          o = dmenuBinding { title = "Desktop Files"; script = scripts.runDesktopFile; };
        };
      };

      inherit keybindings;

      focus.followMouse = false;
    };

    extraConfig = ''
      default_border pixel 1
      title_align center

      for_window [class=${dmenuWindowClass}*] border normal 1
      for_window [class=${dmenuWindowClass}*] floating enable

      for_window [class=home-manager-switch] floating enable
    '';
  };

  # services.polybar = {
  #   enable = true;
  #   package = pkgs.polybar.override {
  #     i3Support = true;
  #     alsaSupport = false;
  #   };
  #   config = {
  #     "bar/top" = {
  #       monitor = "\''${env:MONITOR:eDP1}";
  #       width = "100%";
  #       height = "3%";
  #       radius = 0;
  #       modules-center = "date";
  #     };
  #  };
  # };


  systemd.user = {
    services = {
      i3blocks-date = {
        Unit = { Description = "Update i3blocks date"; };
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.procps}/bin/pkill -SIGRTMIN+2 i3blocks";
        };
      };

      i3blocks-time = {
        Unit = { Description = "Update i3blocks time"; };
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.procps}/bin/pkill -SIGRTMIN+3 i3blocks";
        };
      };

    };

    timers = {
      i3blocks-date = {
        Unit = { Description = "Update i3blocks date daily"; };
        Timer = { OnCalendar = "daily"; Persistent = "true"; };
        Install = { WantedBy = [ "timers.target" "graphical.target" ]; };
      };

      i3blocks-time = {
        Unit = { Description = "Update i3blocks time by the minute"; };
        Timer = { OnCalendar = "minutely"; };
        Install = { WantedBy = [ "timers.target" "graphical.target" ]; };
      };
    };
  };
}
