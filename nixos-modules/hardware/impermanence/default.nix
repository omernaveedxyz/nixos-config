{
  config,
  lib,
  pkgs,
  impermanence,
  ...
}:
let
  inherit (builtins) replaceStrings;
  inherit (lib) mkIf mkBefore;

  wipeScript = ''
    DATE="$(date +%FT%T.%2N)"
    zfs rename "${config.networking.hostName}/root" "${config.networking.hostName}/root_$DATE"
    zfs clone "${config.networking.hostName}/root_$DATE@blank" "${config.networking.hostName}/root"
    zfs promote "${config.networking.hostName}/root"
    zfs rename "${config.networking.hostName}/root_$DATE" "${config.networking.hostName}/root/$DATE"
    zfs set mountpoint=legacy "${config.networking.hostName}/root"
    zfs set mountpoint=legacy "${config.networking.hostName}/root/$DATE"

    DATASETS=$(zfs list -t filesystem \
                        -d 2 \
                        -o name \
                        -H "${config.networking.hostName}/root/$DATE" \
              | tail -n+2)
    for dataset in $DATASETS; do
      zfs rename "$dataset" \
        "${config.networking.hostName}/root/$(echo "$dataset" | cut -d '/' -f 4)"
      zfs set mountpoint=legacy \
        "${config.networking.hostName}/root/$(echo "$dataset" | cut -d '/' -f 4)"
    done

    DATASETS=$(zfs list -t filesystem \
                        -d 2 \
                        -o name \
                        -s name \
                        -H "${config.networking.hostName}/root" \
              | tail -n+2)
    for dataset in $DATASETS; do
      NOW="$(date +%s)"
      THEN="$(date --date="$(echo "$dataset" | cut -d / -f 3 | tr '_' ' ')" +%s)"
      DIFF="$(((NOW - THEN) / (60*60*24)))"
      if [[ $DIFF -gt 7 ]]; then
        zfs destroy "$dataset"
      else
        break
      fi
    done
  '';
in
{
  imports = [ impermanence.nixosModules.impermanence ];

  boot.initrd = mkIf (config._module.args.impermanence) {
    # Names of supported filesystem types in the initial ramdisk
    supportedFilesystems = [ "zfs" ];

    systemd.services.impermanence =
      let
        label = replaceStrings [ "-" ] [ "\\x2d" ] config.networking.hostName;
      in
      {
        # Shell commands executed as the service's main process
        script = wipeScript;

        # Each attribute in this set specifies an option in the [Service] section
        # of the unit
        serviceConfig = {
          Type = "oneshot";
        };

        # Each attribute in this set specifies an option in the [Unit] section of
        # the unit
        unitConfig = {
          DefaultDependencies = "no";
        };

        # Packages added to the services PATH environment variable
        path = with pkgs; [
          zfs
          coreutils
        ];

        # If the specified units are started at the same time as this unit, delay
        # this unit until they have started
        after = [
          "dev-disk-by\\x2dlabel-${label}.device"
          "systemd-cryptsetup@${label}.service"
          "zfs-import-${config.networking.hostName}.service"
        ];

        # Start the specified units when this unit is started, and stop this unit
        # when the specified units are stopped or fail
        requires = [ "dev-disk-by\\x2dlabel-${label}.device" ];

        # If the specified units are started at the same time as this unit, delay
        # them until this unit has started
        before = [ "sysroot.mount" ];

        # Units that want (i.e. depend on) this unit
        wantedBy = [ "initrd.target" ];
      };

    # Shell commands to be executed immediately after stage 1 of the boot has
    # loaded kernel modules and created device nodes in /dev
    postDeviceCommands = mkIf (!config.boot.initrd.systemd.enable) (mkBefore wipeScript);
  };

  # If set, this file system will be mounted in the initial ramdisk
  fileSystems."/persistent".neededForBoot = config._module.args.impermanence;

  # Files and directories to persistent across ephemeral boots
  environment.persistence."/persistent" = mkIf (config._module.args.impermanence) {
    # Allows you to specify whether to hide the bind mounts from showing up as
    # mounted drives in the file manager. If enabled, it sets the mount option
    # x-gvfs-hide on all bind mounts
    hideMounts = true;

    # All directories you want to link or bind to persistent storage
    directories = [
      {
        directory = "/var/lib/nixos";
        user = "root";
        group = "root";
        mode = "0755";
      }
    ];

    # All files you want to link or bind to persistent storage
    files = [
      {
        file = "/etc/machine-id";
        parentDirectory = {
          user = "root";
          group = "root";
          mode = "0755";
        };
      }
    ];
  };
}
