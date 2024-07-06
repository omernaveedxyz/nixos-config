# Custom packages, that can be defined similarly to ones from Nixpkgs
pkgs: {
  # example = pkgs.callPackage ./example { };

  # HACK: https://github.com/nix-community/home-manager/issues/5599
  proton-pass = pkgs.callPackage ./proton-pass { };
}
