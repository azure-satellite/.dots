# TODO: Investigate pkgs.substituteAll for doing templating

{ config, pkgs, ... }:

{
  imports = [ ./user/home-manager ];

  nixpkgs.config = import ./user/home-files/.config/nixpkgs/config.nix;

  home.file.".local" = { source = ./user/home-files/.local; recursive = true; };
  home.file.".config" = { source = ./user/home-files/.config; recursive = true; };
  lib.vars.isNixos = builtins.pathExists /etc/NIXOS;

  # https://github.com/rycee/home-manager/issues/589
  home.activation.sideEffects = config.lib.dag.entryAfter ["writeBoundary"] ''
    ln -sf ${toString ./default.nix} ~/.config/nixpkgs/home.nix
    ${pkgs.stow}/bin/stow -d ${toString ./user} -t ~ mutable
    ${if config.lib.vars.isNixos then "sudo ln -sfT ${toString ./nixos} /etc/nixos" else ""}

    ${pkgs.lib.concatStringsSep "\n" (builtins.attrValues config.lib.activations)}
  '';
}
