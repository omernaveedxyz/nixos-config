{ config, ... }:
{
  disko.devices = {
    disk = {
      "omer-archive" = {
        device = "/dev/sda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            "root" = {
              size = "100%";
              content = {
                type = "luks";
                name = "omer-archive";
                extraOpenArgs = [ "--allow-discards" ];
                initrdUnlock = false;
                settings = {
                  keyFile = "/etc/keyfile";
                };
                content = {
                  type = "zfs";
                  pool = "omer-archive";
                };
              };
            };
          };
        };
      };
    };
    zpool = {
      "omer-archive" = {
        type = "zpool";
        rootFsOptions = {
          canmount = "off";
          mountpoint = "none";
          acltype = "posixacl";
        };
        postCreateHook = ''
          zfs allow ${toString config.users.users.syncoid.uid} change-key,compression,create,mount,mountpoint,receive,rollback,destroy omer-archive
        '';
      };
    };
  };

  # Mount additional encrypted drives using keyfile stored on root partition
  environment.etc."crypttab".text = ''
    omer-archive PARTLABEL=disk-omer-archive-root /etc/keyfile
  '';

  # Name of GUID of extra ZFS pools that you wish to import during boot
  boot.zfs.extraPools = [ "omer-archive" ];
}
