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
  } // config.lib.colors.st;
}
