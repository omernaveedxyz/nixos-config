{ config, ... }:
{
  disko.devices = {
    disk = {
      "omer-media" = {
        device = "/dev/nvme2n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            "root" = {
              size = "100%";
              content = {
                type = "luks";
                name = "omer-media";
                extraOpenArgs = [ "--allow-discards" ];
                initrdUnlock = false;
                settings = {
                  keyFile = "/etc/keyfile";
                };
                content = {
                  type = "zfs";
                  pool = "omer-media";
                };
              };
            };
          };
        };
      };
    };
    zpool = {
      "omer-media" = {
        type = "zpool";
        rootFsOptions = {
          canmount = "off";
          mountpoint = "none";
          acltype = "posixacl";
        };
        datasets = {
          root = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/mnt/media";
            postCreateHook = ''
              zfs allow ${toString config.users.users.syncoid.uid} bookmark,hold,send,snapshot,destroy,mount ${config.networking.hostName}/root
            '';
          };
        };
      };
    };
  };

  # Mount additional encrypted drives using keyfile stored on root partition
  environment.etc."crypttab".text = ''
    omer-media PARTLABEL=disk-omer-media-root /etc/keyfile
  '';
}
