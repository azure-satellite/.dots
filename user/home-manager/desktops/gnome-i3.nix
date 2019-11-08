# https://zork.net/~st/jottings/gnome-i3.html
# https://github.com/deuill/i3-gnome-flashback/blob/master/files/i3-gnome-flashback.desktop

{ config, pkgs, ... }:

let
  sessionName = "gnome-flashback-i3";
in
{
  imports = [
    ../programs/i3.nix
  ];

  home.packages = with pkgs; [
    gnome3.gnome-flashback 
  ];

  lib.activations.copyXSession =
    let
      startSession = pkgs.writeScript sessionName ''
        if [ -z $XDG_CURRENT_DESKTOP ]; then
          export XDG_CURRENT_DESKTOP="GNOME-Flashback:GNOME"
        fi
        exec gnome-session --builtin --session=${sessionName} --disable-acceleration-check "$@"
      '';
      desktop = pkgs.writeText sessionName ''
        [Desktop Entry]
        Name=Gnome Flashback (i3)
        Comment=This session logs you into GNOME Flashback with i3
        Exec=${startSession}
        TryExec=${config.xsession.windowManager.i3.package}/bin/i3
        Type=Application
        DesktopNames=GNOME-Flashback;GNOME;
      '';
    in
    # Anything *.desktop file under /usr/share/xsessions will be available as a
    # session entry in the login screen
    "sudo cp -rf ${desktop} /usr/share/xsessions/${sessionName}.desktop";

  # This is the session file executed by the startSession script above ^^
  # It just lists names of *.desktop files that need to be executed
  xdg.configFile."gnome-session/sessions/${sessionName}.session".text = ''
    [GNOME Session]
    Name=GNOME Flashback (i3)
    RequiredComponents=${pkgs.lib.concatStringsSep ";" [
      "org.gnome.SettingsDaemon.A11ySettings"
      "org.gnome.SettingsDaemon.Color"
      "org.gnome.SettingsDaemon.Datetime"
      "org.gnome.SettingsDaemon.Housekeeping"
      "org.gnome.SettingsDaemon.Keyboard"
      "org.gnome.SettingsDaemon.MediaKeys"
      "org.gnome.SettingsDaemon.Power"
      "org.gnome.SettingsDaemon.PrintNotifications"
      "org.gnome.SettingsDaemon.Rfkill"
      "org.gnome.SettingsDaemon.ScreensaverProxy"
      "org.gnome.SettingsDaemon.Sharing"
      "org.gnome.SettingsDaemon.Smartcard"
      "org.gnome.SettingsDaemon.Sound"
      "org.gnome.SettingsDaemon.Wacom"
      "org.gnome.SettingsDaemon.XSettings"
      "gnome-flashback"
      sessionName
    ]}
  '';

  # This is the desktop file that will get run as part of the session above
  xdg.dataFile."applications/${sessionName}.desktop".text =
    let
      execi3 = pkgs.writeScript "execi3" ''
        # Register with gnome-session so that it does not kill the whole session
        # thinking it is dead.
        if [ -n "$DESKTOP_AUTOSTART_ID" ]; then
          dbus-send \
            --print-reply \
            --session \
            --dest=org.gnome.SessionManager \
            "/org/gnome/SessionManager" \
            org.gnome.SessionManager.RegisterClient \
            "string:${sessionName}" \
            "string:$DESKTOP_AUTOSTART_ID"
        fi

        # Required for i3 and gnome-shell to coexist
        gsettings set org.gnome.desktop.background show-desktop-icons false
        gsettings set org.gnome.gnome-flashback desktop-background true

        # Custom settings
        gsettings set org.gnome.desktop.peripherals.keyboard delay 200
        gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 20
        gsettings set org.gnome.desktop.peripherals.touchpad speed 0.7
        gsettings set org.gnome.desktop.peripherals.tap-and-drag false
        gsettings set org.gnome.desktop.input-sources xkb-options ['caps:ctrl_modifier']

        ${config.xsession.windowManager.i3.package}/bin/i3

        # Close session when i3 exits.
        if [ -n "$DESKTOP_AUTOSTART_ID" ]; then
          dbus-send
            --print-reply \
            --session \
            --dest=org.gnome.SessionManager \
            "/org/gnome/SessionManager" \
            org.gnome.SessionManager.Logout \
            "uint32:1"
        fi
      '';
    in ''
      [Desktop Entry]
      Type=Application
      Name=${sessionName}
      Comment=Improved dynamic tiling window manager
      Exec=${execi3}
      NoDisplay=true
      X-GNOME-WMName=${sessionName}
      X-GNOME-Autostart-Phase=WindowManager
      X-GNOME-Provides=windowmanager
      X-GNOME-Autostart-Notify=false
    '';

  # Other goodies
  xdg.dataFile."applications/logout.desktop".text = ''
    [Desktop Entry]
    Name=Logout
    Exec=gnome-session-quit
    Terminal=false
    Type=Application
    Encoding=UTF-8
    Icon=gnome-session-logout
    Categories=System;TerminalEmulator;
    Keywords=shell;prompt;command;commandline;cmd;
  '';

  xdg.dataFile."applications/reboot.desktop".text = ''
    [Desktop Entry]
    Name=Reboot
    Exec=gnome-session-quit --reboot
    Terminal=false
    Type=Application
    Encoding=UTF-8
    Icon=system-reboot
    Categories=System;TerminalEmulator;
    Keywords=shell;prompt;command;commandline;cmd;
  '';

  xdg.dataFile."applications/shutdown.desktop".text = ''
    [Desktop Entry]
    Name=Shutdown
    Exec=gnome-session-quit --power-off
    Terminal=false
    Type=Application
    Encoding=UTF-8
    Icon=system-shutdown
    Categories=System;TerminalEmulator;
    Keywords=shell;prompt;command;commandline;cmd;
  '';
}
