# See:
# - http://www.charvolant.org/doug/xkb/html/xkb.html
# - https://www.x.org/releases/X11R7.5/doc/input/XKB-Enhancing.html

# The utility `xkbcomp` is used to compile configuration files into a keysym
# table in various (C header, binary *.xkm, ...) formats.

# A symbolic key (keysym) table is essentially a mapping
#   `(keycode, group, state) -> keysym`
# where:
#
# - keycode (0 < i <= 256): Key scan code produced by the keyboard.
# - group   (0 < i <= 4):   Think of a keycode having multiple rows, and this is
#                           an index into that list of rows.
# - state   (0 < i <= 256): Each value represents a modifier key combination.
#                           There can only be 8 modifier keys since 2^8 = 256.
#                           The modifiers are (Shift, Lock, Ctrl, Mod1-Mod5).

# A "shift level" is just a synonym for a given combination of modifier keys.

# One can think of a keysym table as a table (keycodes X shift_levels), except
# for the caveat that a keycode can have up to 4 rows (as specified by its
# groups). Each cell in the table is a keysym.

# The table's maximum size is (256 keycodes * 4 groups * 256 shift levels).
# However, most of the table's cells would be wasted since some keys are not
# affected by modifiers, others only by one, etc... which is why the table is
# reduced as much as possible through "types".

# A type defines which modifiers can affect a keycode. For example, keys of type
# "ONE_LEVEL" are not affected by modifiers and keys of type "TWO_LEVEL" are
# only affected by "Shift", and so on.
#
# If a type is not assigned to a keycode, the following rules apply default
# types, depending on the number and kind of symbol listed for the keycode:
#
# Symbols                             | Assigned type | Affected by
# ------------------------------------|---------------|--------------------
# Only one symbol                     | ONE_LEVEL     | not affected
# One lowercase, one uppercase letter | ALPHABETIC    | shift and capslock
# Any symbol is a keypad symbol       | KEYPAD        | shift and numlock
# Otherwise                           | TWO_LEVEL     | shift

{ config, pkgs, ... }:

with pkgs;
with builtins;

let
  keysyms = import ./keysyms.nix;

  layout = import ./layout.nix;

  modifiers = with keysyms; {
    Shift   = [ Shift_L Shift_R ];
    Lock    = [ Caps_Lock ];
    Control = [ Control_L Control_R ];
    Mod1    = [ Alt_L Meta_L Alt_R Meta_R ];
    Mod2    = [ Num_Lock ];
    Mod3    = [ ];
    Mod4    = [ Super_L Super_R Super_L Hyper_L ];
    Mod5    = [ ISO_Level3_Shift Mode_switch ];
  };

  printAttrs = fn: attrs: concatStringsSep "\n" (attrValues (lib.mapAttrs fn attrs));

  printKeycodes = printAttrs (k: v: ''${k} = ${toString v};'');

  printAliases = printAttrs (k: v: ''alias ${k} = ${v};'');

  printKeymap = printAttrs (k: { type ? "", symbols }: ''
    key ${k} {
      ${if type == "" then "" else "type = \"${type}\","}
      [ ${concatStringsSep ", " symbols} ]
    };
  '');

  printModifiers = printAttrs (k: v: ''modifier_map ${k} { ${concatStringsSep ", " v} };'');

  # "pc+us+inet(evdev)+ctrl(swapcaps)" 
  keymapFile = pkgs.writeText "keymap.xkb" ''
    xkb_keymap {
      xkb_keycodes {
        minimum = 8;
        maximum = 255;
        indicator 1  = "Caps Lock";
        indicator 2  = "Num Lock";
        indicator 3  = "Scroll Lock";
        indicator 4  = "Compose";
        indicator 5  = "Kana";
        indicator 6  = "Sleep";
        indicator 7  = "Suspend";
        indicator 8  = "Mute";
        indicator 9  = "Misc";
        indicator 10 = "Mail";
        indicator 11 = "Charging";
        ${printKeycodes (import ./evdev.nix)}
        ${printAliases (import ./aliases.nix)}
      };
      xkb_symbols {
        name[Group1] = "${layout.name}";
        ${printKeymap layout.symbols}
        ${printModifiers (lib.filterAttrs (k: v: v != []) modifiers)}
      };
      xkb_types  { include "complete" };
      xkb_compat { include "complete" };
    };
  '';

in

{
  home.packages = with xorg; [ xev xkbcomp xkbprint xmodmap ];

  # Use `xmodmap -pke` to inspect differences in layouts
  systemd.user.services.setxkbmap.Service.ExecStart = pkgs.lib.mkForce
    "${xorg.xkbcomp}/bin/xkbcomp ${keymapFile} $DISPLAY";
}
