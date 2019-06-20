{
  allowUnfree = true;
  packageOverrides = pkgs: rec {
    st = pkgs.st.overrideAttrs (old: {
      name = "st-compiled";
      src = ~/Code/suckless/st;
      buildInputs = old.buildInputs ++ [ pkgs.xorg.libXcursor ];
      # src = fetchFromGitHub {
      #   owner = "stellarhoof";
      #   repo = "st";
      #   rev = "config";
      #   sha256 = "0aqs8a7563lm2nkqgfdx8i3zjg2ahp8jnqn1hqxmx00z8n5lygzk";
      # };
    });
  };
}
