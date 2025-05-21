{
  description =
    "A flake giving access to fonts that I use, outside of nixpkgs.";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        defaultPackage = pkgs.symlinkJoin {
          name = "myfonts-0.1.4";
          paths = builtins.attrValues
            self.packages.${system}; # Add font derivation names here
        };

        packages.san-francisco = pkgs.stdenvNoCC.mkDerivation {
          name = "san-francisco";
          dontConfigue = true;
          src = pkgs.fetchzip {
            url =
              "https://github.com/arindamukawlas/fonts/raw/refs/heads/main/apple-fonts.zip";
            sha256 = "sha256-rjwiL36+K5fs7NOGXKGR176X4fU77/BWaXC/RJJKQGY=";
            stripRoot = false;
          };
          installPhase = ''
            mkdir -p $out/share/fonts
            cp -R $src $out/share/fonts/opentype/
          '';
          meta = { description = "A San Francisco Family derivation."; };
        };
      });
}
