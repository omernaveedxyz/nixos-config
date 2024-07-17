{
  config,
  lib,
  relativeToRoot,
  ...
}:
let
  inherit (builtins) readDir concatMap;
  inherit (lib) listToAttrs attrNames;

  devices = attrNames (readDir (relativeToRoot "nixos-configurations"));
in
{
  services.syncoid = {
    # Whether to enable Syncoid ZFS synchronization services
    enable = config._module.args.impermanence;

    # Run syncoid at this interval
    interval = "hourly";

    # SSH private key file to use to login to the remote system
    sshKey = config.sops.secrets."services/syncoid/sshKey".path;

    # Arguments to add to every syncoid command
    commonArgs = [
      "--no-sync-snap"
      "--sshoption=StrictHostKeyChecking=off"
    ];

    # Syncoid commands to run
    commands =
      listToAttrs (
        concatMap (device: [
          {
            name = "syncoid@${device}:${device}/persistent";
            value = {
              target = "syncoid@omer-desktop:omer-vault/${device}";
            };
          }
          {
            name = "syncoid@omer-desktop:omer-vault/${device}";
            value = {
              target = "syncoid@omer-desktop:omer-archive/${device}";
            };
          }
        ]) devices
      )
      // {
        "syncoid@omer-desktop:omer-media/root" = {
          # Target ZFS dataset
          target = "syncoid@omer-desktop:omer-vault/omer-media";
        };
        "syncoid@omer-desktop:omer-vault/omer-media" = {
          # Target ZFS dataset
          target = "syncoid@omer-desktop:omer-archive/omer-media";
        };
      };
  };

  services.sanoid.datasets =
    listToAttrs (
      concatMap (name: [
        {
          name = "omer-vault/${name}";
          value = {
            # Whether to automatically prune old snapshots
            autoprune = true;

            # Whether to automatically take snapshots
            autosnap = false;

            # Number of hourly snapshots
            hourly = 168;

            # Number of daily snapshots
            daily = 15;

            # Number of monthly snapshots
            monthly = 0;

            # Number of yearly snapshots
            yearly = 0;
          };
        }
        {
          name = "omer-archive/${name}";
          value = {
            # Whether to automatically prune old snapshots
            autoprune = true;

            # Whether to automatically take snapshots
            autosnap = false;

            # Number of hourly snapshots
            hourly = 360;

            # Number of daily snapshots
            daily = 30;

            # Number of monthly snapshots
            monthly = 0;

            # Number of yearly snapshots
            yearly = 0;
          };
        }
      ]) devices
    )
    // {
      "omer-vault/omer-media" = {
        # Whether to automatically prune old snapshots
        autoprune = true;

        # Whether to automatically take snapshots
        autosnap = false;

        # Number of hourly snapshots
        hourly = 168;

        # Number of daily snapshots
        daily = 15;

        # Number of monthly snapshots
        monthly = 0;

        # Number of yearly snapshots
        yearly = 0;
      };
      "omer-archive/omer-media" = {
        # Whether to automatically prune old snapshots
        autoprune = true;

        # Whether to automatically take snapshots
        autosnap = false;

        # Number of hourly snapshots
        hourly = 360;

        # Number of daily snapshots
        daily = 30;

        # Number of monthly snapshots
        monthly = 0;

        # Number of yearly snapshots
        yearly = 0;
      };
    };

  # Specify encrypted sops secret to access
  sops.secrets."services/syncoid/sshKey" = {
    sopsFile = relativeToRoot "nixos-configurations/${config.networking.hostName}/secrets.yaml";
    owner = "syncoid";
    group = "syncoid";
    mode = "0600";
  };
}
