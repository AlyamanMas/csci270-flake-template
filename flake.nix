{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in
    {
      devShells."x86_64-linux" = {
        default =
          (pkgs.buildFHSUserEnv {
            name = "cuda-env";
            targetPkgs =
              pkgs: with pkgs; [
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

                # Required for CUDA. Taken from "https://nixos.org/manual/nixpkgs/stable/#sec-fhs-environments"
                git
                gitRepo
                gnupg
                autoconf
                curl
                procps
                gnumake
                util-linux
                m4
                gperf
                unzip
                cudatoolkit
                linuxPackages.nvidia_x11
                libGLU
                libGL
                xorg.libXi
                xorg.libXmu
                freeglut
                xorg.libXext
                xorg.libX11
                xorg.libXv
                xorg.libXrandr
                zlib
                ncurses5
                stdenv.cc
                binutils
              ];
            multiPkgs = pkgs: with pkgs; [ zlib ];
            runScript = "bash";
            profile = ''
              export CUDA_PATH=${pkgs.cudatoolkit}
              # export LD_LIBRARY_PATH=${pkgs.linuxPackages.nvidia_x11}/lib
              export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
              export EXTRA_CCFLAGS="-I/usr/include"
            '';
          }).env;
      };
      formatter."x86_64-linux" = pkgs.nixfmt-rfc-style;
    };
}
