{ config, pkgs, ... }:

with pkgs; let

scripts = config.lib.functions.writeShellScriptsBin {
  brightness = ''
    set -e
    dev=/sys/class/backlight/intel_backlight
    output() {
      x=$(${coreutils}/bin/cat $dev/actual_brightness)
      y=$(${coreutils}/bin/cat $dev/max_brightness)
      echo $(($x * 100 / $y))
    }

    output
    ${inotify-tools}/bin/inotifywait -q -m -e modify $dev/actual_brightness | while read event; do output; done
  '';

  mail = ''
    set -e
    shopt -s nullglob
    dir=~/Mail
    dirs=$(${findutils}/bin/find $dir/* -maxdepth 0 -type d)
    towatch=$(${findutils}/bin/find $dir/* -maxdepth 1 -type d -name Inbox -exec ${coreutils}/bin/echo -n "{}/new {}/cur " \;)
    output() {
      out=""
      for maildir in $dirs; do
        unread=$(${findutils}/bin/find $maildir/Inbox/{new,cur} -type f | ${gnugrep}/bin/grep -vE ',[^,]*S[^,]*$' | ${coreutils}/bin/wc -l)
        base="$(${coreutils}/bin/basename $maildir)"
        if [[ $unread > 0 ]]; then
          out+="$base ($unread) — "
        fi
      done
      if [[ -n $out ]]; then
        echo "''${out:0:(-3)}"
      else
        echo ""
      fi
    }
    output
    ${inotify-tools}/bin/inotifywait -q -m -e create,delete,move $towatch | while read event; do output; done
    shopt -u nullglob
  '';
};

in {
  services.polybar = {
    enable = true;
    script = "polybar top &";
    package = pkgs.polybar.override {
      i3GapsSupport = true;
      pulseSupport = true;
    };
    # label/format/animation configuration keys support appending:
    # - background
    # - foreground
    # - padding
    # - margin
    # - underline
    # - overline
    # - font
    # - offset
    # ex: label-focused-background = #fafafa
    config = with config.lib.colors; {
      # https://github.com/polybar/polybar/wiki/Configuration#bar-settings
      "bar/top" = with config.lib; {
        dpi = "";
        font-0 = "${functions.xftString fonts.ui};7";
        font-1 = "${functions.xftString (fonts.ui // { size = fonts.ui.size + 1; })};7";
        foreground = theme.default.fg;
        background = "#cb4b16";
        border-size = "3";
        border-top-size = "0";
        border-color = "#f45a1a";
        height = "60";
        fixed-center = true;
        cursor-click = "pointer";
        cursor-scroll = "ns-resize";
        modules-left = "apps mail";
        modules-center = "i3";
        modules-right = "brightness pulseaudio wireless battery datetime powerbutton";
      };

      # https://github.com/polybar/polybar/wiki/Module:-text
      "module/apps" = {
        type = "custom/text";
        content = "%{T2}􀕯%{T-}";
        content-padding = "2";
        content-background = "#8e350f";
      };

      # https://github.com/polybar/polybar/wiki/Module:-i3
      "module/i3" = {
        type = "internal/i3";
        # Only show workspaces defined on the same output as the bar;
        #;
        # Useful if you want to show monitor specific workspaces;
        # on different bars;
        #;
        # Default: false;
        pin-workspaces = "false";
        # This will split the workspace name on ':';
        # Default: false;
        strip-wsnumbers = "false";
        # Sort the workspaces by index instead of the default;
        # sorting that groups the workspaces by output;
        # Default: false;
        index-sort = "false";
        # Create click handler used to focus workspace;
        # Default: true;
        enable-click = "true";
        # Create scroll handlers used to cycle workspaces;
        # Default: true;
        enable-scroll = "false";
        # Wrap around when reaching the first/last workspace;
        # Default: true;
        wrapping-scroll = "false";
        # Set the scroll cycle direction ;
        # Default: true;
        reverse-scroll = "false";
        # Use fuzzy (partial) matching on labels when assigning ;
        # icons to workspaces;
        # Example: code;♚ will apply the icon to all workspaces ;
        # containing 'code' in the label;
        # Default: false;
        fuzzy-match = "false";
        # ws-icon-[0-9]+="label;icon";
        # NOTE: The label needs to match the name of the i3 workspace;
        # NOTE: You cannot skip icons, e.g. to get a ws-icon-6 you must also
        # define a;;
        # ws-icon-5.;
        # ws-icon-0 = "1;􀀀";
        # ws-icon-1 = "2;􀀀";
        # ws-icon-2 = "3;􀀀";
        # ws-icon-3 = "4;􀀀";
        # ws-icon-4 = "5;􀀀";
        # ws-icon-5 = "6;􀀀";
        # ws-icon-6 = "7;􀀀";
        # ws-icon-7 = "8;􀀀";
        # ws-icon-8 = "9;􀀀";
        # ws-icon-default = "􀀀";
        # Available tokens: %mode%;
        # Default: %mode%;
        label-mode = "%mode%";
        label-mode-background = "#b74414";
        label-mode-padding = "4";
        # Available tokens: %name% %icon% %index% %output%;
        # Default: %icon%  %name%;
        label-focused = "􀀁";
        label-unfocused = "􀀁";
        label-urgent = "􀀀";
        label-focused-padding = "2";
        label-unfocused-padding = "2";
        label-urgent-padding = "2";
        label-unfocused-foreground = "#ff621d";
        # Available tags:;
        #   <label-state> (default) - gets replaced with
        #   <label-(focused|unfocused|visible|urgent)>;;
        #   <label-mode> (default);
        format = "<label-state> <label-mode>";
        format-background = "#cb4b16";
        format-padding = 2;
        format-font = 2;
      };

      # https://github.com/polybar/polybar/wiki/Module:-script
      "module/mail" = {
        type = "custom/script";
        exec = scripts.mail.bin;
        tail = "true";
        label = "􀈨 %output%";
        format = "<label>";
        format-background = "#b74414";
        format-padding = "4";
      };

      # https://github.com/polybar/polybar/wiki/Module:-script
      "module/brightness" = {
        type = "custom/script";
        exec = scripts.brightness.bin;
        tail = "true";
        label = "%{T2}􀆮%{T-} %output%%";
        format = "<label>";
        format-background = "#df5318";
        format-padding = "4";
      };

      # https://github.com/polybar/polybar/wiki/Module:-pulseaudio
      "module/pulseaudio" = {
        type = "internal/pulseaudio";
        # Sink to be used, if it exists (find using `pacmd list-sinks`, name
        # field);;
        # If not, uses default sink;
        # sink = "alsa_output.pci-0000_12_00.3.analog-stereo";
        # Use PA_VOLUME_UI_MAX (~153%) if true, or PA_VOLUME_NORM (100%) if
        # false;;
        # Default: true;
        use-ui-max = "true";
        # Interval for volume increase/decrease (in percent points);
        # Default: 5;
        interval = "5";
        # Only applies if <ramp-volume> is used;
        ramp-volume-0 = "􀊡";
        ramp-volume-1 = "􀊥";
        ramp-volume-2 = "􀊧";
        ramp-volume-3 = "􀊩";
        # Available tokens:;
        #   %percentage% (default);
        label-volume = "%percentage%%";
        # Available tags:;
        #   <label-volume> (default);
        #   <ramp-volume>;
        #   <bar-volume>;
        format-volume = "<ramp-volume> <label-volume>";
        format-volume-background = "#cb4b16";
        format-volume-padding = "4";
        # Available tokens:;
        #   %percentage% (default);
        label-muted = "􀊣%percentage%%";
        # Available tags:;
        #   <label-muted> (default);
        #   <ramp-volume>;
        #   <bar-volume>;
        format-muted = "<label-muted>";
        format-muted-background = "#cb4b16";
        format-muted-padding = "4";
      };

      # https://github.com/polybar/polybar/wiki/Module:-network
      "module/wireless" = {
        type = "internal/network";
        interface = "wlp59s0";
        interval = "3";
        # All labels support the following tokens:;
        #   %ifname%    [wireless+wired];
        #   %local_ip%  [wireless+wired];
        #   %local_ip6% [wireless+wired];
        #   %essid%     [wireless];
        #   %signal%    [wireless];
        #   %upspeed%   [wireless+wired];
        #   %downspeed% [wireless+wired];
        #   %linkspeed% [wired];
        # Default: %ifname% %local_ip%;
        label-connected = "%{T2}􀙇%{T-} %signal%%";
        # Available tags:;
        #   <label-connected> (default);
        #   <ramp-signal>;
        format-connected = "<label-connected>";
        format-connected-background = "#b74414";
        format-connected-padding = "4";
        # Same tokens as label-connected;
        label-disconnected = "􀙈";
        # Available tags:;
        #   <label-disconnected> (default);
        format-disconnected = "<label-disconnected>";
        format-disconnected-background = "#b74414";
        format-disconnected-padding = "4";
        # Same tokens as label-connected;
        label-packetloss = "􀙥";
        # Available tags:;
        #   <label-connected> (default);
        #   <label-packetloss>;
        #   <animation-packetloss>;
        format-packetloss = "<label-packetloss>";
        format-packetloss-background = "#b74414";
        format-packetloss-padding = "4";
      };

      # https://github.com/polybar/polybar/wiki/Module:-battery
      "module/battery" = {
        type = "internal/battery";
        # Use the following command to list batteries and adapters:;
        # $ ls -1 /sys/class/power_supply/;
        adapter = "AC";
        battery = "BAT0";
        # If an inotify event hasn't been reported in this many;
        # seconds, manually poll for new values.;
        #;
        # Needed as a fallback for systems that don't report events;
        # on sysfs/procfs.;
        #;
        # Disable polling by setting the interval to 0.;
        #;
        # Default: 5;
        poll-interval = "5";
        # Only applies if <ramp-capacity> is used;
        ramp-capacity-0 = "􀛪";
        ramp-capacity-1 = "􀛩";
        ramp-capacity-2 = "􀛨";
        # Available tokens:;
        #   %percentage% (default) - is set to 100 if full-at is reached;
        #   %percentage_raw% (unreleased);
        #   %time%;
        #   %consumption% (shows current charge rate in watts);
        label-charging = "􀘴 %percentage%%";
        # Available tags:;
        #   <label-charging> (default);
        #   <bar-capacity>;
        #   <ramp-capacity>;
        #   <animation-charging>;
        format-charging = "<label-charging>";
        format-charging-background = "#a23c12";
        format-charging-padding = "4";
        # Available tokens:;
        #   %percentage% (default) - is set to 100 if full-at is reached;
        #   %percentage_raw% (unreleased);
        #   %time%;
        #   %consumption% (shows current discharge rate in watts);
        label-discharging = "%percentage%%";
        # Available tags:;
        #   <label-discharging> (default);
        #   <bar-capacity>;
        #   <ramp-capacity>;
        #   <animation-discharging>;
        format-discharging = "<ramp-capacity> <label-discharging>";
        format-discharging-background = "#a23c12";
        format-discharging-padding = "4";
        # Available tokens:;
        #   %percentage% (default) - is set to 100 if full-at is reached;
        #   %percentage_raw% (unreleased);
        label-full = "%percentage%";
        # Available tags:;
        #   <label-full> (default);
        #   <bar-capacity>;
        #   <ramp-capacity>;
        format-full = "<ramp-capacity> <label-full>";
      };

      # https://github.com/polybar/polybar/wiki/Module:-date
      "module/datetime" = {
        type = "internal/date";
        time = "%l:%M %p";
        label = "􀐮 %time%";
        format = "<label>";
        format-background = "#a23c12";
        format-padding = "2";
      };

      # https://github.com/polybar/polybar/wiki/Module:-text
      "module/powerbutton" = {
        type = "custom/text";
        content = "%{T2}􀆨%{T-}";
        content-padding = "2";
        content-background = "#8e350f";
      };
    };
  };

  xsession.windowManager.i3.config = {
    bars = [];
    startup = [
      {
        command = "systemctl --user restart polybar";
        always = true;
        notification = false;
      }
    ];
  };
}
