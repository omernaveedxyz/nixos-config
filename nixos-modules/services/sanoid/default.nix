{ config, lib, ... }:
let
  inherit (lib) mkIf;
in
{
  services.sanoid = {
    # Whether to enable Sanoid ZFS snapshotting services
    enable = true;

    # Run sanoid at this interval
    interval = "hourly";

    # Attribute set of (dataset/template options)
    datasets = {
      "${config.networking.hostName}/persistent" = {
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
      "omer-media/root" = mkIf (config.networking.hostName == "omer-desktop") {
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