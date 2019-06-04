{ config, pkgs, ... }:

with pkgs;

let

  vimdiff = {
    cmd = ''${neovim}/bin/nvim -f -c "Gdiff" "$MERGED"'';
    keepBackup = false;
    trustExitCode = true; # So we can abort with :cq
  };

  diffconflicts = {
    cmd = ''${neovim}/bin/nvim -c DiffConflicts "$MERGED" "$BASE" "$LOCAL" "$REMOTE"'';
    trustExitCode = true;
  };

in

{
  home.packages = [ gitAndTools.hub ];

  programs.git = {
    enable = true;

    userEmail = config.accounts.email.accounts.sidekick.address;

    userName = config.accounts.email.accounts.sidekick.realName;

    aliases = {
      # Merging/Diffing
      df = "diff";
      dfn = "diff --name-only";
      dfc = "diff --cached";
      dfp = "diff --patch-with-stat --diff-algorithm=minimal";
      dt = "difftool";
      mt = "mergetool";
      conflicts = "!git diff --name-only --diff-filter=U";

      # Listing
      l = "log --pretty=format:'%C(yellow)%h %ad%Cred%d %Creset%s%Cblue [%cn]' --decorate --date=short";
      ll = "log --pretty=format:'%C(yellow)%h %ad%Cred%d %Creset%s%Cblue [%cn]' --decorate --numstat";
      la = "!git config --list | grep alias | cut -c 7-";
      ls = "ls-files";

      # Commit
      cm = "commit";
      cmm = "commit -m";
      cma = "commit --amend";
      cman = "commit --amend --no-edit";

      # Other
      gr = "grep";
      bl = "blame -w -M";
      st = "status";
      sh = "stash";
      co = "checkout";
      br = "branch -v";
      re = "rebase";
      set-upstream = "!git branch --set-upstream-to=origin/$(git symbolic-ref --short HEAD)";

      # External Tools
      # tig
      lga = "!tig --all";
      # hub
      pro = "pull-request -a stellarhoof --push --browse";
      prls = "pr list -f '%sC%>(8)%i%Creset %Cyellow%<(17)%au%Creset %Cblue%U%Creset %t%n'";
    };

    ignores = [
      # Compiled source
      "*.com" "*.class" "*.dll" "*.exe" "*.o" "*.so" "*.pyc"
      # Packages
      # It's better to unpack these files and commit the raw source git has
      # its own built in compression methods
      "*.7z" "*.dmg" "*.gz" "*.iso" "*.jar" "*.rar" "*.tar" "*.zip"
      # Logs and databases
      "*.log" "*.sqlite"
      # OS generated files
      ".DS_Store" ".DS_Store?" "._*" ".Spotlight-V100" ".Trashes" "ehthumbs.db" "Thumbs.db"
      # Direnv
      ".direnv" ".envrc"
      # Misc
      ".ropeproject" ".mypy_cache" ".vscode"
    ];

    includes = [{
      condition = "gitdir:${config.home.homeDirectory}/Code/src/smartprocure/";
      contents = {
        user = with config.accounts.email.accounts.smartprocure; {
          email = address;
          name = realName;
        };
      };
    }];

    extraConfig = {
      core = { autocrlf = false; whitespace = "cr-at-eol"; };
      pager = { status = false; branch = false; };
      push = { default = "simple"; };
      diff = { tool = "vimdiff"; };
      merge = { tool = "vimdiff"; };
      difftool = { prompt = false; keepBackup = false; };
      mergetool = { prompt = true; keepBackup = false; };
      "difftool \"vimdiff\"" = vimdiff;
      "mergetool \"vimdiff\"" = vimdiff;
      "difftool \"diffconflicts\"" = diffconflicts;
      "mergetool \"diffconflicts\"" = diffconflicts;
      grep = { extendRegexp = true; lineNumber = true; };
      "filter \"lfs\"" = {
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
        required = true;
        clean = "git-lfs clean -- %f";
      };
      color = { ui = true; };
      "color \"branch\"" = {
        current = "red";
        upstream = "red";
        local = "yellow";
        plain = "yellow";
        remote = "green";
      };
      "color \"status\"" = {
        added = "green";
        changed = "yellow";
        untracked = "red";
        header = "reset";
        branch = "yellow";
        localBranch = "yellow";
      };
      "color \"diff\"" = {
        meta = "cyan bold";
      };
    };
  };
}
