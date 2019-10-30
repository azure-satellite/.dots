# TODO: Investigate pkgs.substituteAll for doing templating

{ config, pkgs, ... }:

{
  imports = [ ./user/home-manager ];

  nixpkgs.config = import ./user/home-files/.config/nixpkgs/config.nix;

  home.file.".local" = { source = ./user/home-files/.local; recursive = true; };
  home.file.".config" = { source = ./user/home-files/.config; recursive = true; };
  lib.vars.isNixos = builtins.pathExists /etc/NIXOS;

  # https://github.com/rycee/home-manager/issues/589
  home.activation.linkMyFiles = config.lib.dag.entryAfter ["writeBoundary"] ''
    ln -sf ${toString ./default.nix} ~/.config/nixpkgs/home.nix
    ln -sf ${toString ./user/mutable/.config/nvim} ~/.config/
    ln -sf ${toString ./user/mutable/.config/sway} ~/.config
    ln -sf ${toString ./user/mutable/.local/share/pass} ~/.local/share/
    ${if config.lib.vars.isNixos then "sudo ln -sfT ${toString ./nixos} /etc/nixos" else ""}
  '';
}
