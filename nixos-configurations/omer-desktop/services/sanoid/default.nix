{ config, lib, ... }:
let
  inherit (lib) mkIf;
in
{
  services.sanoid = mkIf (config.services.sanoid.enable) {
    # Attribute set of (dataset/template options)
    datasets = {
      "omer-media/root" = {
        # Whether to automatically prune old snapshots
        autoprune = true;

        # Whether to automatically take snapshots
        autosnap = true;

        # Number of hourly snapshots
        hourly = 24;

        # Number of daily snapshots
        daily = 7;

        # Number of monthly snapshots
        monthly = 0;

        # Number of yearly snapshots
        yearly = 0;
      };
    };
  };
}
