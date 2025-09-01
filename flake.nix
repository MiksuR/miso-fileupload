{
  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [ inputs.haskell-flake.flakeModule ];

      perSystem = { system, config, pkgs, ... }: {
        haskellProjects.default = {
          packages = {
            miso.source = inputs.miso;
          };
          autoWire = [ "packages" "apps" ];
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [ config.haskellProjects.default.outputs.devShell ];
          packages = [
            pkgs.ghcid
            pkgs.gnumake
            inputs.ghc-wasm-meta.packages.${system}.all_9_12
          ];
        };

        packages.default = config.packages.miso-fileupload;
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    haskell-flake.url = "github:srid/haskell-flake";
    miso.url = "github:dmjio/miso";
    ghc-wasm-meta.url = "gitlab:haskell-wasm/ghc-wasm-meta?host=gitlab.haskell.org";
  };
}
