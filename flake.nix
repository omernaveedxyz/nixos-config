{
  inputs = {
    # Nix Packages collection & NixOS
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # Simplify Nix Flakes with the module system
    flake-parts.url = "github:hercules-ci/flake-parts";

    # A flake-parts module for simple nixos, darwin and home-manager configurations
    ez-configs.url = "github:ehllie/ez-configs";
    ez-configs.inputs.nixpkgs.follows = "nixpkgs";

    # Manage a user environment using Nix
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{ flake-parts, ez-configs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [ ez-configs.flakeModule ];

      ezConfigs = {
        # The root from which configurations and modules should be searched
        root = ./.;

        # Extra arguments to pass to all configurations
        globalArgs = {
          inherit inputs;
        };

        # Settings for creating nixosConfigurations
        nixos.hosts = {
          omer-laptop = {
            userHomeModules = [ "omer" ];
          };
        };
      };

      perSystem =
        { pkgs, ... }:
        {
          # Run a bash shell that provides the build environment of a derivation
          devShells.default = pkgs.mkShell { packages = with pkgs; [ ]; };

          # Reformat your code in the standard style
          formatter = pkgs.nixfmt-rfc-style;
        };
    };
}
