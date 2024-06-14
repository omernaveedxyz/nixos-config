{ config, ... }:
{
  disko.devices = {
    disk = {
      "omer-vault" = {
        device = "/dev/nvme1n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            "root" = {
              size = "100%";
              content = {
                type = "luks";
                name = "omer-vault";
                extraOpenArgs = [ "--allow-discards" ];
                initrdUnlock = false;
                settings = {
                  keyFile = "/etc/keyfile";
                };
                content = {
                  type = "zfs";
                  pool = "omer-vault";
                };
              };
            };
          };
        };
      };
    };
    zpool = {
      "omer-vault" = {
        type = "zpool";
        rootFsOptions = {
          canmount = "off";
          mountpoint = "none";
          acltype = "posixacl";
        };
        postCreateHook = ''
          zfs allow ${toString config.users.users.syncoid.uid} change-key,compression,create,mount,mountpoint,receive,rollback,destroy ${config.networking.hostName}
        '';
      };
    };
  };

  # Mount additional encrypted drives using keyfile stored on root partition
  environment.etc."crypttab".text = ''
    omer-vault PARTLABEL=disk-omer-vault-root /etc/keyfile
  '';
}
