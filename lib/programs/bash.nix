{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ bash ];
  programs.bash = {
    enable = true;
    historyControl = [ "erasedups" "ignorespace" ];
    historyFile = "${config.home.homeDirectory}/.cache/bash_history";
    historyIgnore = [ "\"&" "[ ]*" "exit" "ls" "bg" "fg" "env" "history" "clear\"" ];
    shellAliases = config.lib.aliases;
    shellOptions = [
      "checkwinsize" "globstar" "globasciiranges" "direxpand"
      "dirspell" "histappend" "cmdhist" "autocd" "cdspell"
    ];
    bashrcExtra = ''
      export NVM_DIR="$HOME/.config/nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
      [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    '';
    profileExtra = with config.home; ''
      . ${profileDirectory}/etc/profile.d/nix.sh
      export NIX_PATH="${homeDirectory}/.nix-defexpr/channels:nixpkgs=${homeDirectory}/.nix-defexpr/channels"
    '';
  };
}
