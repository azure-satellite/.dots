{ config, pkgs, lib, ... }:

let

# Warning. Hacky indent code ahead!
attrSetToLuaTable = v: indent: ''{''\n${config.lib.functions.reduceAttrsToString ",\n" (k: v: ''${indent}${k} = ${toLuaValue v (indent + "  ")}'') v}''\n${indent}}'';

toLuaValue = with builtins; with lib.trivial;
  v: indent: if isAttrs v then attrSetToLuaTable v indent else if isBool v then boolToString v else ''"${v}"'';

in

{
  # Uncomment once https://github.com/NixOS/nixpkgs/pull/80528 is merged
  # home.packages = with pkgs; [
  #   (neovim.override {
  #     viAlias = true;
  #     vimAlias = true;
  #     withNodeJs = true;
  #   })
  # ];

  xdg.configFile."nvim/lua/theme.lua".text = ''return ${toLuaValue config.lib.colors.theme "  "}'';
}
