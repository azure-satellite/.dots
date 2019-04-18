# TODO: Investigate pkgs.substituteAll for doing templating

{ config, pkgs, ... }:

{
  imports = [ ./home-manager ];

  nixpkgs.config = import ./home-files/.config/nixpkgs/config.nix;

  home.file.".local" = { source = ./home-files/.local; recursive = true; };
  home.file.".config" = { source = ./home-files/.config; recursive = true; };

  # https://github.com/rycee/home-manager/issues/589
  # TODO: Figure out why links are being created inside ./mutable/*
  home.activation.linkMyFiles = config.lib.dag.entryAfter ["writeBoundary"] ''
    ln -sf ${toString ./default.nix} ~/.config/nixpkgs/home.nix
    ln -sf ${toString ./mutable/.config/nvim} ~/.config/
    ln -sf ${toString ./mutable/.local/share/pass} ~/.local/share/
  '';
}
