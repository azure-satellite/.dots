{ config, pkgs, ... }:

let
  NPM_PACKAGES = "${config.xdg.dataHome}/npm";
in
{
  home.packages = with pkgs; [ nodejs_latest yarn ];

  home.sessionVariables = with config.home; with config.xdg; {
    inherit NPM_PACKAGES;
    PATH = "$PATH:${NPM_PACKAGES}/bin";
    NPM_CONFIG_USERCONFIG = "${configHome}/npm/npmrc.local";
    NPM_CONFIG_GLOBALCONFIG = "${configHome}/npm/npmrc.global";
    NODE_REPL_MODE = "strict";
    NODE_PATH = "${NPM_PACKAGES}/lib/node_modules:$NODE_PATH";
    NODE_REPL_HISTORY = "${cacheHome}/node_repl_history";
  };

  xdg.configFile."npm/npmrc.global".text = with config.home; with config.xdg; ''
    prefix=${NPM_PACKAGES}
    cache=${cacheHome}/npm
    init-module=${configHome}/npm/npm-init.js
    globalignorefile=${configHome}/npm/npmignore
  '';
}
