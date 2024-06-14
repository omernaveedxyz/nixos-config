{
  config,
  disko,
  device,
  ...
}:
{
  imports = [ disko.nixosModules.disko ];

  disko.devices = {
    disk = {
      "${config.networking.hostName}" = {
        inherit device;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            "boot" = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            "root" = {
              size = "100%";
              content = {
                type = "luks";
                name = "${config.networking.hostName}";
                extraOpenArgs = [ "--allow-discards" ];
                passwordFile = "/tmp/disk.key";
                content = {
                  type = "zfs";
                  pool = "${config.networking.hostName}";
                };
              };
            };
          };
        };
      };
    };
    zpool = {
      "${config.networking.hostName}" = {
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
            mountpoint = "/";
            postCreateHook = "zfs snapshot ${config.networking.hostName}/root@blank";
          };
          nix = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/nix";
          };
          persistent = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/persistent";
          };
          log = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/var/log";
          };
        };
      };
    };
  };
}
