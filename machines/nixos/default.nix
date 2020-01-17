{ config, pkgs, ... }:

{
  imports = [
    ../../lib/common.nix
    ../../lib/common.linux.nix
    ../../lib/desktops/none.nix
  ];

  lib.activations.installSystemFiles = ''
    sudo ln -sfT ${toString ./system} /etc/nixos
  '';
}
