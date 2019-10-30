{ config, pkgs, ... }:

with pkgs;

{
  imports = [
    ./direnv.nix
    ./fzf.nix
    ./git.nix
    ./node.nix
    ./python.nix
    ./nvim.nix
    ./fish.nix
  ];

  home.packages = [
    brave
    calibre
    ffmpeg
    imagemagick
    pandoc
    pass
    ripgrep
    robo3t
    slack
    tokei
    transmission-gtk
    tree
    universal-ctags
    unrar
    vscode
    xclip
    youtube-dl
  ];

  programs.bash = {
    enable = true;
    historyControl = [ "erasedups" "ignorespace" ];
    historyFile = "${config.lib.vars.home}/.cache/bash_history";
    historyIgnore = [ "\"&" "[ ]*" "exit" "ls" "bg" "fg" "env" "history" "clear\"" ];
    shellAliases = config.lib.aliases;
    shellOptions = [
      "checkwinsize" "globstar" "globasciiranges" "direxpand"
      "dirspell" "histappend" "cmdhist" "autocd" "cdspell"
    ];
    profileExtra = ''
      ${lib.optionalString (!config.lib.vars.isNixos) ''. "${nix}/etc/profile.d/nix.sh"''}
    '';

  };

  lib.aliases = {
    cp-png = "${pkgs.xclip}/bin/xclip -selection clipboard -t image/png";
    cloc = "tokei";
    rg = ''rg --glob \"!package-lock.json\" --glob \"!package.json\" --glob \"!.git/*\" --smart-case --hidden'';
    grep = config.lib.aliases.rg;
    tree = "tree -sha --dirsfirst -I .git";
    code = "code --extensions-dir ${config.lib.vars.home}/.config/Code/extensions";
  };

  home.sessionVariables = with config.lib.vars; {
    # Default applications
    # The whole userBin thing is so these variables point to the correct one
    # if we build a different version
    BROWSER = "${userBin}/brave";
    EDITOR = "${userBin}/nvim";
    VISUAL = "${userBin}/nvim";
    PAGER = "${systemBin}/less";
    MANPAGER = "${systemBin}/less -s -M";
  };

  xdg.mimeApps.defaultApplications = with config.lib.mimetypes; with config.lib.functions;
    (defaultMimeApp "nvim.desktop" text) //
    (defaultMimeApp "brave-browser.desktop" xscheme) //
    {
      "application/epub+zip" = "calibre-ebook-viewer.desktop";
    };
}
