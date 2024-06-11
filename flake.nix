{
  inputs = {
    # Simplify Nix Flakes with the module system
    flake-parts.url = "github:hercules-ci/flake-parts";

    # Nix Packages collection & NixOS
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      perSystem =
        { config, pkgs, ... }:
        {
          packages.hello = pkgs.hello;

          packages.default = config.packages.hello;

          formatter = pkgs.nixfmt-rfc-style;
        };
    };
}
