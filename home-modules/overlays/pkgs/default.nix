# Custom packages, that can be defined similarly to ones from Nixpkgs
pkgs: {
  # example = pkgs.callPackage ./example { };
  proton-pass = pkgs.callPackage ./proton-pass { };
}
