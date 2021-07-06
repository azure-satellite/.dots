# https://github.com/alacritty/alacritty/blob/master/alacritty.yml

{ config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      # Alacritty with direct (RGB, true color) color support
      env = { TERM = "alacritty-direct"; };
      window = {
        decorations = "none";
        startup_mode = "Fullscreen";
      };
      font = with config.lib.fonts; {
        normal = { family = "SFMono Nerd Font"; style = "Regular"; };
        bold = { family = "SFMono Nerd Font"; style = "Bold"; };
        italic = { family = "SFMono Nerd Font"; style = "Italic"; };
        bold_italic = { family = "SFMono Nerd Font"; style = "Bold Italic"; };
        size = 15;
        offset = { y = 7; };
        glyph_offset = { y = 4; };
        # This is totally broken on MacOS
        # use_thin_strokes = true;
      };
      colors = config.lib.colors.alacritty;
      shell = {
        program = "${config.home.profileDirectory}/bin/fish";
        # args = [ "-l" ];
        args = [ "-l" "-C" "tmux attach -t alacritty || tmux new -t alacritty" ];
      };
      live_config_reload = false;
      selection = { save_to_clipboard = true; };
      mouse = { hide_when_typing = true; };
      key_bindings = [
        # Tmux Windows
        # Get the chars by running `xxd -psd`. The first two chars is the CTRL
        # modifier code and the last are the actual keys.
        { key = "T"; mods = "Command"; chars = "\\x02\\x63"; } # New window
        { key = "LBracket"; mods = "Command"; chars = "\\x02\\x70"; } # Select previous window
        { key = "RBracket"; mods = "Command"; chars = "\\x02\\x6e"; } # Select next window
        { key = "W"; mods = "Command"; chars = "\\x02\\x26"; } # Kill window
        { key = "LBracket"; mods = "Command|Shift"; chars = "\\x02\\x7b"; } # Move window left
        { key = "RBracket"; mods = "Command|Shift"; chars = "\\x02\\x7d"; } # Move window right

        # Tmux Panes
        { key = "N"; mods = "Command"; chars = "\\x02\\x22"; } # New horizontal pane
        { key = "M"; mods = "Command"; chars = "\\x02\\x25"; } # New vertical pane
        { key = "K"; mods = "Command"; chars = "\\x02\\x1b\\x5b\\x41"; } # Select pane up
        { key = "J"; mods = "Command"; chars = "\\x02\\x1b\\x5b\\x42"; } # Select pane down
        { key = "L"; mods = "Command"; chars = "\\x02\\x1b\\x5b\\x43"; } # Select pane right
        { key = "H"; mods = "Command"; chars = "\\x02\\x1b\\x5b\\x44"; } # Select pane left
        { key = "O"; mods = "Command"; chars = "\\x02\\x7a"; } # Maximize pane
        { key = "Period"; mods = "Command"; chars = "\\x02\\x78"; } # Kill pane

        # Option as Meta(Alt)
        # https://github.com/alacritty/alacritty/issues/62
        { key = "A"; mods = "Alt"; chars = "\\x1ba"; }
        { key = "B"; mods = "Alt"; chars = "\\x1bb"; }
        { key = "C"; mods = "Alt"; chars = "\\x1bc"; }
        { key = "D"; mods = "Alt"; chars = "\\x1bd"; }
        { key = "E"; mods = "Alt"; chars = "\\x1be"; }
        { key = "F"; mods = "Alt"; chars = "\\x1bf"; }
        { key = "G"; mods = "Alt"; chars = "\\x1bg"; }
        { key = "H"; mods = "Alt"; chars = "\\x1bh"; }
        { key = "I"; mods = "Alt"; chars = "\\x1bi"; }
        { key = "J"; mods = "Alt"; chars = "\\x1bj"; }
        { key = "K"; mods = "Alt"; chars = "\\x1bk"; }
        { key = "L"; mods = "Alt"; chars = "\\x1bl"; }
        { key = "M"; mods = "Alt"; chars = "\\x1bm"; }
        { key = "N"; mods = "Alt"; chars = "\\x1bn"; }
        { key = "O"; mods = "Alt"; chars = "\\x1bo"; }
        { key = "P"; mods = "Alt"; chars = "\\x1bp"; }
        { key = "Q"; mods = "Alt"; chars = "\\x1bq"; }
        { key = "R"; mods = "Alt"; chars = "\\x1br"; }
        { key = "S"; mods = "Alt"; chars = "\\x1bs"; }
        { key = "T"; mods = "Alt"; chars = "\\x1bt"; }
        { key = "U"; mods = "Alt"; chars = "\\x1bu"; }
        { key = "V"; mods = "Alt"; chars = "\\x1bv"; }
        { key = "W"; mods = "Alt"; chars = "\\x1bw"; }
        { key = "X"; mods = "Alt"; chars = "\\x1bx"; }
        { key = "Y"; mods = "Alt"; chars = "\\x1by"; }
        { key = "Z"; mods = "Alt"; chars = "\\x1bz"; }
      ];
    };
  };
}
