{ config, pkgs, ... }:

with pkgs.lib;

let

  fzfColors = with builtins; concatStringsSep "," (attrValues (mapAttrs (k: v: "${k}:${v}") config.lib.colors.fzf));

  FZF_DEFAULT_COMMAND = "command ${config.lib.aliases.rg} --files --no-ignore-vcs";

  FZF_DEFAULT_OPTS = toString [
    "--color=${fzfColors}"
    "--cycle"
    "--filepath-word"
    "--inline-info"
    "--reverse"
    "--pointer='*'"
    "--preview='head -100 {}'"
    "--preview-window=right:hidden"
    "--bind=ctrl-space:toggle-preview"
  ];

in

{
  home.sessionVariables = { inherit FZF_DEFAULT_COMMAND FZF_DEFAULT_OPTS; };

  programs = {
    fzf = rec {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = false;
      enableZshIntegration = false;
    };

    fish.interactiveShellInit = ''
      bind -e \ec
      bind \co fzf-cd-widget
      if bind -M insert >/dev/null 2>/dev/null
        bind -M insert -e \ec
        bind -M insert \co fzf-cd-widget
      end
    '';
  };
}
