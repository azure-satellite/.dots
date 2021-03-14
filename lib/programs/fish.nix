{ config, pkgs, ... }:

with pkgs.lib;

let

  colorDefToString = name: def: ''
    set -U ${name} ${builtins.concatStringsSep " " [
      (if hasAttr "fg" def then "'${def.fg}'" else "")
      (if hasAttr "bg" def then "--background='${def.bg}'" else "")
      (if hasAttr "italic" def then "--italics" else "")
      (if hasAttr "bold" def then "--bold" else "")
      (if hasAttr "underline" def then "--underline" else "")
      (if hasAttr "reverse" def then "--reverse" else "")
    ]}
  '';

in

{
  programs.fish = {
    enable = true;
    shellAliases = config.lib.aliases;
    loginShellInit = ''
      set fish_complete_path ${config.home.profileDirectory}/share/fish/vendor_completions.d $fish_complete_path
      set fish_function_path ${pkgs.fishPlugins.foreign-env}/share/fish-foreign-env/functions ${config.home.profileDirectory}/share/fish/vendor_functions.d $fish_function_path
    '';
    interactiveShellInit = with config.lib.functions; ''
      set fish_greeting
      set -U fish_prompt_pwd_dir_length 0
      ${reduceAttrsToString "\n" colorDefToString config.lib.colors.fish}
    '';
  };

  # This git configuration gets read by the fish_git_prompt function
  # Run fish_config and navigate to the functions tab to read its source
  programs.git = {
    extraConfig = {
      bash = {
        showDirtyState = true;
      };
    };
  };

  xdg.configFile."fish/functions" = {
    recursive = true;
    source = ./fish/functions;
  };
}
