{
  config,
  lib,
  disko,
  device,
  ...
}:
let
  inherit (lib) mkIf;
in
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
          persistent = mkIf (config._module.args.impermanence) {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/persistent";
            postCreateHook = ''
              zfs allow ${toString config.users.users.syncoid.uid} bookmark,hold,send,snapshot,destroy,mount ${config.networking.hostName}/persistent
            '';
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
