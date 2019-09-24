# TODO: Investigate pkgs.substituteAll for doing templating

{ config, pkgs, ... }:

{
  imports = [ ./user/home-manager ];

  nixpkgs.config = import ./user/home-files/.config/nixpkgs/config.nix;

  home.file.".local" = { source = ./user/home-files/.local; recursive = true; };
  home.file.".config" = { source = ./user/home-files/.config; recursive = true; };

  # https://github.com/rycee/home-manager/issues/589
  home.activation.linkMyFiles = config.lib.dag.entryAfter ["writeBoundary"] ''
    ln -sf ${toString ./default.nix} ~/.config/nixpkgs/home.nix
    ln -sf ${toString ./user/mutable/.config/nvim} ~/.config/
    ln -sf ${toString ./user/mutable/.config/Code/User} ~/.config/Code
    ln -sf ${toString ./user/mutable/.local/share/pass} ~/.local/share/
    sudo ln -sfT ${toString ./system} /etc/nixos
  '';
}
