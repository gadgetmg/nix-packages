{
  description = "Nix packages";
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} (
      {withSystem, ...}: {
        systems = inputs.nixpkgs.lib.systems.flakeExposed;

        imports = [
          inputs.pkgs-by-name-for-flake-parts.flakeModule
        ];

        perSystem = {system, ...}: {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          pkgsDirectory = ./pkgs;
        };

        flake = {
          overlays.default = final: prev:
            withSystem prev.stdenv.hostPlatform.system (
              {config, ...}: config.packages
            );
        };
      }
    );
}
