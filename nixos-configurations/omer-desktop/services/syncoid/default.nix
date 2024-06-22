{
  config,
  lib,
  relativeToRoot,
  ...
}:
let
  inherit (builtins) readDir;
  inherit (lib) listToAttrs attrNames;
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
        map (device: {
          name = "syncoid@${device}:${device}/persistent";
          value = {
            # Target ZFS dataset
            target = "syncoid@omer-desktop:omer-vault/${device}";
          };
        }) (attrNames (readDir (relativeToRoot "nixos-configurations")))
        ++ map (device: {
          name = "syncoid@omer-desktop:omer-vault/${device}";
          value = {
            # Target ZFS dataset
            target = "syncoid@omer-desktop:omer-archive/${device}";
          };
        }) (attrNames (readDir (relativeToRoot "nixos-configurations")))
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
      map (name: {
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
      }) (attrNames (readDir (relativeToRoot "nixos-configurations")))
      ++ map (name: {
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
      }) (attrNames (readDir (relativeToRoot "nixos-configurations")))
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
