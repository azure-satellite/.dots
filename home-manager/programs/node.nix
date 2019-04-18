{ config, pkgs, ... }:

{
  home.packages = [ pkgs.nodejs ];

  lib.sessionVariables = with config.home; rec {
    # Node/npm
    NPM_PACKAGES = "${homeDirectory}/.local/share/npm";
    PATH = "${homeDirectory}/.local/bin:${NPM_PACKAGES}/bin:$PATH";
    NPM_CONFIG_USERCONFIG = "${homeDirectory}/.config/npm/npmrc";
    NPM_CONFIG_GLOBALCONFIG = "${NPM_CONFIG_USERCONFIG}";
    NODE_REPL_MODE = "strict";
    NODE_PATH = "${NPM_PACKAGES}/lib/node_modules:$NODE_PATH";
    NODE_REPL_HISTORY = "${homeDirectory}/.cache/node_repl_history";
  };

  xdg.configFile."npm/npmrc".text = with config.home; ''
    prefix=${config.lib.sessionVariables.NPM_PACKAGES}
    cache=${homeDirectory}/.cache/npm
    init-module=${homeDirectory}/.config/npm/npm-init.js
    globalignorefile=${homeDirectory}/.config/npm/npmignore
    cafile=${config.lib.sessionVariables.SSL_CERT_FILE}
  '';
}
