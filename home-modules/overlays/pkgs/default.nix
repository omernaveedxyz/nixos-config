# Custom packages, that can be defined similarly to ones from Nixpkgs
pkgs: {
  # example = pkgs.callPackage ./example { };
  proton-pass = pkgs.callPackage ./proton-pass { }; # TODO: https://github.com/nix-community/home-manager/issues/5599
}
