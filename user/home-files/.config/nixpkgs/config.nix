let

  # # Using builtins.fetchTarball without a sha256 will only cache the download
  # # for 1 hour by default, so you need internet access almost every time you
  # # build something. You can pin the version if you don't want that:
  # nur = builtins.fetchTarball {
  #   # Get the revision by choosing a version from https://github.com/nix-community/NUR/commits/master
  #   url = "https://github.com/nix-community/NUR/archive/b662518cd0e9d127185e1a3e4dab1dfadd8a5288.tar.gz";
  #   # Get the hash by running `nix-prefetch-url --unpack <url>` on the above url
  #   sha256 = "0gpyphln1v5599k2hxpfyyw2n9m9a088jyv6z4cbcr92l89p6aqq";
  # };

in

{
  allowUnfree = true;
  packageOverrides = pkgs: {
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

    calibre = pkgs.calibre.overrideAttrs (old: {
      buildInputs = old.buildInputs ++ [ pkgs.gtk3 ];
      nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.makeWrapper pkgs.wrapGAppsHook ];
    });
  };
}
