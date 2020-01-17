{ config, pkgs, ... }:

with pkgs;

{
  home.packages = [
    (st.overrideAttrs (old: {
      name = "st-compiled";
      src = ../../gitmodules/st;
      buildInputs = old.buildInputs ++ [ xorg.libXcursor ];
    }))
  ];

  xresources.properties = with config.lib.colors.theme; {
    "st.termname"    = "st-256color";
    "st.borderpx"    = 0;
    "st.font"        = with config.lib; functions.xftString (fonts.mono // { size = fonts.mono.size * 4; });
    "st.color0"      = black;
    "st.color1"      = red;
    "st.color2"      = green;
    "st.color3"      = yellow;
    "st.color4"      = blue;
    "st.color5"      = magenta;
    "st.color6"      = cyan;
    "st.color7"      = white;
    "st.color8"      = base0;
    "st.color9"      = base1;
    "st.color10"     = base2;
    "st.color11"     = base3;
    "st.color12"     = base4;
    "st.color13"     = base5;
    "st.color14"     = base6;
    "st.color15"     = base7;
    "st.cursorColor" = cursor.bg;
    "st.foreground"  = text.fg;
    "st.background"  = text.bg;
  };
}
