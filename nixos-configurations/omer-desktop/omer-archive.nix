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
      };
    };
  };

  # Mount additional encrypted drives using keyfile stored on root partition
  environment.etc."crypttab".text = ''
    omer-archive PARTLABEL=disk-omer-archive-root /etc/keyfile
  '';
}
