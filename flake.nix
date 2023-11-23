{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in rec {
        packages = {
          default = packages.psd2svg;
          psd2svg = pkgs.python3.pkgs.buildPythonPackage rec {
            pname = "psd2svg";
            version = "master";
            format = "setuptools";

            doCheck = false;

            src = builtins.path {
              path = ./.;
              name = "psd2svg";
            };

            propagatedBuildInputs = with pkgs.python3Packages; [
              psd-tools
              svgwrite
              future
            ];

            postPatch = ''
              substituteInPlace setup.py --replace \'pytest-runner\' ""
            '';
          };
        };

        formatter = pkgs.nixfmt;
      });
}
