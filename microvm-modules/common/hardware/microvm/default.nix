{
  lib,
  impermanence,
  hostname,
  relativeToRoot,
  ...
}:
let
  inherit (lib) mkDefault;
in
{
  imports = [ impermanence.nixosModules.impermanence ];

  microvm = {
    # Number of virtual CPU cores
    vcpu = 8;

    # Amount of RAM in megabytes
    mem = 8192;

    # Shared directory trees
    shares = [
      {
        # Protocol for this share
        proto = "virtiofs";

        # Unique virtiofs daemon tag
        tag = "ro-store";

        # Path to shared directory tree
        source = "/nix/store";

        # Where to mount the share inside the container
        mountPoint = "/nix/.ro-store";
      }
      {
        # Protocol for this share
        proto = "virtiofs";

        # Unique virtiofs daemon tag
        tag = "persistent";

        # Path to shared directory tree
        source = "/var/lib/microvms/${hostname}/persistent";

        # Where to mount the share inside the container
        mountPoint = "/persistent";
      }
    ];

    # Network interfaces
    interfaces = mkDefault [
      {
        # Interface type
        type = "user";

        # Interface name on the host
        id = "eth0";

        # MAC address of the guest's network interface
        mac = "02:00:00:00:00:01";
      }
    ];
  };

  # Path of the source file
  environment.etc."machine-id".source = (
    relativeToRoot "microvm-configurations/${hostname}/machine-id"
  );

  # The file systems to be mounted
  fileSystems."/persistent".neededForBoot = true;

  # Files and directories to persist across ephemeral boots
  environment.persistence."/persistent" = {
    # Allows you to specify whether to hide the bind mounts from showing up
    # as mounted drives in the file manager. If enabled, it sets the mount
    # option x-gvfs-hide on all the bind mounts
    hideMounts = true;

    # All directories you want to link or bind to persistent storage
    directories = [
      {
        directory = "/var/log/journal";
        user = "root";
        group = "systemd-journal";
        mode = "u=rwx,g=rx+s,o=rx";
      }
      {
        directory = "/etc/ssh";
        user = "root";
        group = "root";
        mode = "0755";
      }
    ];
  };
}
