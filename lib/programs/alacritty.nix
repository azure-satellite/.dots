{ config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      # Alacritty with direct (RGB, true color) color support
      env = { TERM = "alacritty-direct"; };
      window = {
        decorations = "buttonless";
        startup_mode = "Maximized";
      };
      # background_opacity = 0.7;
      font = with config.lib.fonts; {
        normal = { family = mono.name; style = "Regular"; };
        bold = { family = mono.name; style = "Bold"; };
        italic = { family = mono.name; style = "Italic"; };
        bold_italic = { family = mono.name; style = "Bold Italic"; };
        size = mono.size * 2;
        use_thin_strokes = true;
      };
      colors = config.lib.colors.alacritty;
      shell = {
        program = "${config.home.profileDirectory}/bin/fish";
        args = [ "-l" "-C" "tmux attach -t alacritty || tmux new -t alacritty" ];
      };
      live_config_reload = false;
      selection = { save_to_clipboard = true; };
      mouse = { hide_when_typing = true; };
      # Get the chars by running `xxd -psd`. The first two is the CTRL modifier
      # code and the last are the actual keys.
      key_bindings = [
        # Windows
        { key = "T"; mods = "Command"; chars = "\\x02\\x63"; } # New window
        { key = "LBracket"; mods = "Command"; chars = "\\x02\\x70"; } # Select previous window
        { key = "RBracket"; mods = "Command"; chars = "\\x02\\x6e"; } # Select next window
        { key = "Key1"; mods = "Command"; chars = "\\x02\\x31"; } # window 1
        { key = "Key2"; mods = "Command"; chars = "\\x02\\x32"; } # window 2
        { key = "Key3"; mods = "Command"; chars = "\\x02\\x33"; } # window 3
        { key = "Key4"; mods = "Command"; chars = "\\x02\\x34"; } # window 4
        { key = "Key5"; mods = "Command"; chars = "\\x02\\x35"; } # window 5
        { key = "Key6"; mods = "Command"; chars = "\\x02\\x36"; } # window 6
        { key = "Key7"; mods = "Command"; chars = "\\x02\\x37"; } # window 7
        { key = "Key8"; mods = "Command"; chars = "\\x02\\x38"; } # window 8
        { key = "Key9"; mods = "Command"; chars = "\\x02\\x39"; } # window 9
        { key = "W"; mods = "Command"; chars = "\\x02\\x26"; } # Kill window

        # Panes
        { key = "N"; mods = "Command"; chars = "\\x02\\x22"; } # New horizontal pane
        { key = "M"; mods = "Command"; chars = "\\x02\\x25"; } # New vertical pane
        { key = "K"; mods = "Command"; chars = "\\x02\\x1b\\x5b\\x41"; } # Select pane up
        { key = "J"; mods = "Command"; chars = "\\x02\\x1b\\x5b\\x42"; } # Select pane down
        { key = "L"; mods = "Command"; chars = "\\x02\\x1b\\x5b\\x43"; } # Select pane right
        { key = "H"; mods = "Command"; chars = "\\x02\\x1b\\x5b\\x44"; } # Select pane left
        { key = "O"; mods = "Command"; chars = "\\x02\\x7a"; } # Maximize pane
        { key = "Period"; mods = "Command"; chars = "\\x02\\x78"; } # Kill pane

        { key = "R"; mods = "Command|Shift"; chars = "\\x02\\x52"; } # Reload config

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
