{ config, pkgs, ... }:
let
  NPM_PACKAGES = "${config.xdg.dataHome}/npm";
in
{
  home.packages = with pkgs; [ nodejs-14_x ];

  lib.vars = { inherit NPM_PACKAGES; };

  # https://docs.npmjs.com/cli/v7/configuring-npm/npmrc
  # https://docs.npmjs.com/cli/v7/using-npm/config

  home.sessionVariables = with config.home; with config.xdg; {
    inherit NPM_PACKAGES;
    NPM_CONFIG_USERCONFIG = "${configHome}/npm/npmrc.local";
    NPM_CONFIG_GLOBALCONFIG = "${configHome}/npm/npmrc.global";
    NODE_REPL_MODE = "strict";
    NODE_REPL_HISTORY = "${cacheHome}/node_repl_history";
  };

  xdg.configFile."npm/npmrc.global".text = with config.home; with config.xdg; ''
    prefix=${NPM_PACKAGES}
    cache=${cacheHome}/npm
    init-module=${configHome}/npm/npm-init.js
    globalignorefile=${configHome}/npm/npmignore
  '';
}
