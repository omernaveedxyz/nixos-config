{
  config,
  lib,
  pkgs,
  relativeToRoot,
  ...
}:
let
  inherit (builtins) readDir;
  inherit (lib)
    listToAttrs
    filter
    attrNames
    getExe
    mkIf
    ;
in
{
  services.syncoid = mkIf (config.networking.hostName == "omer-desktop") {
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
            target = "omer-vault/${device}";
          };
        }) (attrNames (readDir (relativeToRoot "nixos-configurations")))
        ++ map (device: {
          name = "syncoid@omer-desktop:omer-vault/${device}";
          value = {
            # Target ZFS dataset
            target = "omer-archive/${device}";
          };
        }) (attrNames (readDir (relativeToRoot "nixos-configurations")))
      )
      // {
        "syncoid@omer-desktop:omer-media/root" = {
          # Target ZFS dataset
          target = "omer-vault/omer-media";
        };
        "syncoid@omer-desktop:omer-vault/omer-media" = {
          # Target ZFS dataset
          target = "omer-archive/omer-media";
        };
      };
  };

  services.sanoid.datasets = mkIf (config.networking.hostName == "omer-desktop") (
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
    }
  );

  # A list of files each containing one OpenSSH public key that should be added
  # to the user's authorized keys
  users.users.syncoid.openssh.authorizedKeys.keyFiles = [
    (relativeToRoot "nixos-configurations/omer-desktop/syncoid.pub")
  ];

  # Additional user accounts to be created automatically by the system.
  users.users.syncoid = {
    # The user’s primary group
    group = "syncoid";

    # Indicates if the user is a system user or not
    isSystemUser = true;

    # The user’s home directory
    home = "/var/lib/syncoid";

    # Whether to create the home directory and ensure ownership as well as permissions to match the user
    createHome = false;

    # The account UID
    uid = 993;

    # The set of packages that should be made available to the user
    packages = with pkgs; [
      pv
      mbuffer
      lzop
      zstd
    ];

    # The path to the user's shell
    shell = getExe pkgs.bash;
  };

  # Additional groups to be created automatically by the system
  users.groups.syncoid = {
    # The group GID
    gid = 993;
  };

  # Specify encrypted sops secret to access
  sops.secrets."services/syncoid/sshKey" = mkIf (config.networking.hostName == "omer-desktop") {
    sopsFile = relativeToRoot "nixos-configurations/${config.networking.hostName}/secrets.yaml";
    owner = "syncoid";
    group = "syncoid";
    mode = "0600";
  };
}
