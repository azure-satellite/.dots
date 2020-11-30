{ config, pkgs, ... }:

{
  # Uncomment once https://github.com/NixOS/nixpkgs/pull/80528 is merged
  # home.packages = with pkgs; [
  #   (neovim.override {
  #     viAlias = true;
  #     vimAlias = true;
  #     withNodeJs = true;
  #   })
  # ];

  xdg.configFile."nvim/lua/colors.lua".text = ''
    ${pkgs.lib.concatImapStringsSep "\n"
      (i: v: ''vim.g.terminal_color_${toString (i - 1)} = "${v}"'') 
			(with config.lib.colors.theme; [
				black red green yellow blue magenta cyan white
				base0 base1 base2 base3 base4 base5 base6 base7
			])
		}
    return { ${
      config.lib.functions.reduceAttrsToString
      ", "
      (name: color: ''${name} = "${color}"'')
      (with config.lib.colors.theme; { inherit
        black red green yellow blue magenta cyan white
        base0 base1 base2 base3 base4 base5 base6 base7;
      })
    } }
	'';
}
