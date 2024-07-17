{ config, lib, ... }:
let
  inherit (lib) mkOption elem getName;
  inherit (lib.types) listOf str;
in
{
  options = {
    allowedUnfree = mkOption {
      type = listOf str;
      default = [ ];
    };
  };

  config = {
    nixpkgs.config.allowUnfreePredicate = pkg: elem (getName pkg) config.allowedUnfree;
  };
}
