# Good overview about networking tools in Linux (that site is awesome for
# documentation in general)
# - https://openwrt.org/docs/guide-developer/networking/network.interfaces

# - Network interfaces over at `/sys/class/net`
# - Also list them with `ip address show` or `ip link show`

# wpa_supplicant specific options:
# networking.wireless.*

# powerManagement.resumeCommands = ''
#   ${config.systemd.package}/bin/systemctl try-restart wpa_supplicant
# '';

# # Restart wpa_supplicant when a wlan device appears or disappears.
# services.udev.extraRules = ''
#   ACTION=="add|remove", SUBSYSTEM=="net", ENV{DEVTYPE}=="wlan", RUN+="${config.systemd.package}/bin/systemctl try-restart wpa_supplicant.service"
# '';

# See https://wiki.archlinux.org/index.php/Dhcpcd for how to use it with iwd
# Also useful information over at
# https://bbs.archlinux.org/viewtopic.php?id=237074

# DNS Bullshit
# See:
# - https://roy.marples.name/projects/openresolv
# - Run `resolvconf -l` to list all `resolv.conf` configurations (tunnel, static, dhcp, etc...)

{ config, pkgs, ... }:

with pkgs;

{
  environment = {
    systemPackages = [
      (pkgs.writeShellScriptBin "add-network.sh" ''
        dir=/var/lib/iwd
        mkdir -p $dir

        # Only SSIDs with alphanumeric characters and -_ are allowed. The rest have to
        # be hex encoded. However, iwctl has a bug that doesn't allow SSIDs with - or _.
        # Hence this script.
        if [[ $1 =~ ^[0-9a-zA-Z_-]+$ ]]; then
            filename="$1.psk"
        else
            # Convert SSID into hexadecimal representation for filename
            filename="=$(echo -n "$1" | ${coreutils}/bin/od -A n -t x1 | ${gnused}/bin/sed 's/ //g').psk"
        fi

        output=$(${wpa_supplicant}/bin/wpa_passphrase "$1" "$2")

        cat > "$dir/$filename" << EOF
        [Security]
        PreSharedKey=$(echo $output | ${gnugrep}/bin/grep -o -P '[^#]psk=\K\w+')
        EOF
      '')

      (pkgs.writeShellScriptBin "restart-openvpn.sh" ''
      '')
    ];
  };

  # Uncomment this if the networking configuration becomes unstable and we need
  # internet for resolving it.
  networking.networkmanager.enable = true;

  # https://wiki.archlinux.org/index.php/Iwd
  # networking.wireless.iwd.enable = true;

  # https://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/
  networking.usePredictableInterfaceNames = true;

  services.openvpn.servers = {
    smartprocure = {
      config = builtins.readFile "/home/berserk/Secret/smartprocure.ovpn";
      updateResolvConf = true;
      autoStart = false;
    };

    expressvpn = {
      config = builtins.readFile "/home/berserk/Secret/expressvpn.ovpn";
      updateResolvConf = true;
      autoStart = false;
      authUserPass = {
        username = "mllnl2bnk2re8izohqfubwg6";
        password = "cmg3mvxvn2n3a26g53yiqedj";
      };
    };
  };

  # https://wiki.archlinux.org/index.php/OpenVPN#Client_daemon_not_reconnecting_after_suspend
  systemd.services."openvpn-reconnect" = {
    description = "Restart OpenVPN after suspend";
    serviceConfig = {
      ExecStart = "${procps}/bin/pkill --signal SIGHUP --exact openvpn";
    };
    wantedBy = [ "sleep.target" ];
  };
}
