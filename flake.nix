{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgs = forAllSystems (system: nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (system: {
        default = pkgs.${system}.mkShellNoCC {
          packages = with pkgs.${system}; [
            jupyter-all
            python312Packages.numpy
            python312Packages.pandas
            python312Packages.matplotlib
            python312Packages.scikit-learn
            python312Packages.scipy

            # Required for matplotlib to display with GTK4Cairo backend
            librsvg
            python312Packages.pygobject3
            python312Packages.pycairo
            gtk4
          ];
          shellHook = ''
            export MPLBACKEND="GTK4Cairo"
          '';
        };
      });
      formatter = forAllSystems (system: pkgs.${system}.nixfmt-rfc-style);
    };
}
