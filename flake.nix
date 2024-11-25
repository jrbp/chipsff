{
  description = "Chips FF";

  inputs = {
    dream2nix.url = "github:nix-community/dream2nix";
    nixpkgs.follows = "dream2nix/nixpkgs";
  };

  outputs = {
    self,
    dream2nix,
    nixpkgs,
  }: let
    eachSystem = nixpkgs.lib.genAttrs [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  in {
    packages = eachSystem (system: {
      default = self.packages.${system}.chipsff;
      chipsff = dream2nix.lib.evalModules {
        packageSets.nixpkgs = nixpkgs.legacyPackages.${system};
        modules = [
          ./default.nix
          {
            paths.projectRoot = ./.;
            paths.projectRootFile = "flake.nix";
            paths.package = ./.;
          }
        ];
      };
    });
    devShells = eachSystem (system: {
      default = nixpkgs.legacyPackages.${system}.mkShell {
        inputsFrom = [self.packages.${system}.default.devShell];
        packages = with nixpkgs.legacyPackages.${system}; [
          uv
          ruff
          pyright
          self.packages.${system}.default.config.deps.python.pkgs.ipython
        ];
      };
    });
  };
}
