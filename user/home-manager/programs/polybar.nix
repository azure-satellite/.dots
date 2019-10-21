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
    script = "polybar main &";
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

    # (2160-4) / 44 = 49
    config = with config.lib.colors.theme; {
      # https://github.com/polybar/polybar/wiki/Configuration#bar-settings
      "bar/main" = with config.lib; {
        bottom = true;
        dpi = "";
        font-0 = "${functions.xftString fonts.ui};3";
        font-1 = "${functions.xftString (fonts.ui // { size = fonts.ui.size + 1.5; })};3";
        foreground = text.fg;
        # foreground = primary.fg;
        background = text.bg;
        # background = primary.bg;
        line-size = 3;
        border-top-size = 2;
        # border-color = "#f45a1a";
        border-color = base4;
        height = 94;
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
        content-padding = 2;
        content-background = primary.bg;
        # content-background = "#8e350f";
      };

      # https://github.com/polybar/polybar/wiki/Module:-i3
      "module/i3" = {
        type = "internal/i3";
        enable-scroll = false;
        ws-icon-0 = "1;􀀻";
        ws-icon-1 = "2;􀀽";
        ws-icon-2 = "3;􀀿";
        ws-icon-3 = "4;􀁁";
        ws-icon-4 = "5;􀁃";
        ws-icon-5 = "6;􀁅";
        ws-icon-6 = "7;􀁇";
        ws-icon-7 = "8;􀁉";
        ws-icon-8 = "9;􀁋";
        label-mode = "%mode%";
        label-mode-background = primary.bg;
        # label-mode-background = "#b74414";
        label-mode-padding = 4;
        label-focused = "%icon%";
        label-focused-background = primary.bg;
        # label-focused-background = "#f45a1a";
        label-focused-underline = primary.fg;
        label-focused-padding = 1;
        label-unfocused = "%icon%";
        label-unfocused-padding = 1;
        label-urgent = "%icon%";
        label-urgent-padding = 1;
        format = "<label-state> <label-mode>";
        format-background = primary.bg;
        # format-background = "#cb4b16";
        format-padding = 2;
        format-font = 2;
      };

      # There's https://github.com/polybar/polybar/issues/1842 but I rely on
      # this too much to disable it
      # https://github.com/polybar/polybar/wiki/Module:-script
      "module/mail" = {
        type = "custom/script";
        exec = scripts.mail.bin;
        tail = true;
        label = "%output%";
        format = "􀈨 <label>";
        format-background = primary.bg;
        # format-background = "#b74414";
        format-padding = 4;
      };

      # # Disabling until https://github.com/polybar/polybar/issues/1842 gets fixed
      # # https://github.com/polybar/polybar/wiki/Module:-script
      # "module/brightness" = {
      #   type = "custom/script";
      #   exec = scripts.brightness.bin;
      #   tail = true;
      #   label = "%output%%";
      #   format = "%{T2}􀆮%{T-} <label>";
      #   format-background = "#df5318";
      #   format-padding = 4;
      # };

      # # Disabling until
      # # https://github.com/polybar/polybar/issues/1842 gets fixed
      # # https://github.com/polybar/polybar/wiki/Module:-pulseaudio
      # "module/pulseaudio" = {
      #   type = "internal/pulseaudio";
      #   ramp-volume-0 = "􀊡";
      #   ramp-volume-1 = "􀊥";
      #   ramp-volume-2 = "􀊧";
      #   ramp-volume-3 = "􀊩";
      #   label-volume = "%percentage%%";
      #   format-volume = "<ramp-volume> <label-volume>";
      #   format-volume-background = "#cb4b16";
      #   format-volume-padding = 4;
      #   label-muted = "%percentage%%";
      #   format-muted = "􀊣 <label-muted>";
      #   format-muted-background = "#cb4b16";
      #   format-muted-padding = 4;
      # };

      # https://github.com/polybar/polybar/wiki/Module:-network
      "module/wireless" = {
        type = "internal/network";
        interface = "wlp59s0";
        interval = 5;
        label-connected = "%signal%%";
        format-connected = "%{T2}􀙇%{T-} <label-connected>";
        format-connected-background = primary.bg;
        # format-connected-background = "#cb4b16";
        format-connected-padding = 4;
        format-disconnected = "􀙈";
        format-disconnected-background = primary.bg;
        # format-disconnected-background = "#cb4b16";
        format-disconnected-padding = 4;
        format-packetloss = "􀙥";
        format-packetloss-background = primary.bg;
        # format-packetloss-background = "#cb4b16";
        format-packetloss-padding = 4;
      };

      # https://github.com/polybar/polybar/wiki/Module:-battery
      "module/battery" = {
        type = "internal/battery";
        adapter = "AC";
        battery = "BAT0";
        poll-interval = 5;
        ramp-capacity-0 = "􀛪";
        ramp-capacity-1 = "􀛩";
        ramp-capacity-2 = "􀛨";
        label-full = "%percentage%%";
        format-full = "<ramp-capacity> <label-full>";
        format-full-background = primary.bg;
        # format-full-background = "#b74414";
        format-full-padding = 4;
        label-charging = "%percentage%%";
        format-charging = "􀘴 <label-charging>";
        format-charging-background = primary.bg;
        # format-charging-background = "#b74414";
        format-charging-padding = 4;
        label-discharging = "%percentage%%";
        format-discharging = "<ramp-capacity> <label-discharging>";
        format-discharging-background = primary.bg;
        # format-discharging-background = "#b74414";
        format-discharging-padding = 4;
      };

      # https://github.com/polybar/polybar/wiki/Module:-date
      "module/datetime" = {
        type = "internal/date";
        time = "%l:%M %p";
        label = "%time%";
        format = "􀐮 <label>";
        format-background = primary.bg;
        # format-background = "#a23c12";
        format-padding = 2;
      };

      # https://github.com/polybar/polybar/wiki/Module:-text
      "module/powerbutton" = {
        type = "custom/text";
        content = "%{T2}􀆨%{T-}";
        content-background = primary.bg;
        # content-background = "#8e350f";
        content-padding = 2;
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
