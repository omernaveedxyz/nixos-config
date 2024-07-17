{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe;

  radarr-create-movies-directory = pkgs.writeShellScriptBin "radarr-create-movies-directory" ''
    if [ ! -d /mnt/media/Movies ]; then
      ${pkgs.coreutils}/bin/mkdir -p /mnt/media/Movies
      ${pkgs.coreutils}/bin/chown -R radarr:radarr /mnt/media/Movies
      ${pkgs.coreutils}/bin/chmod -R 0775 /mnt/media/Movies
      ${pkgs.acl}/bin/setfacl -R -d -m u::rwx,g::rwx,o::rx /mnt/media/Movies
      ${pkgs.coreutils}/bin/chmod -R g+s /mnt/media/Movies
    fi
  '';
in
{
  services.radarr = {
    # Whether to enable Radarr
    enable = true;

    # Open ports in the firewall for the Radarr web interface
    openFirewall = true;
  };

  # The user’s auxiliary groups
  users.users.radarr.extraGroups = [
    "qbittorrent"
    "sabnzbd"
  ];

  microvm.forwardPorts = [
    {
      # Controls the direction in which the ports are mapped
      #
      # - <literal>"host"</literal> means traffic from the host ports
      # is forwarded to the given guest port.
      #
      # - <literal>"guest"</literal> means traffic from the guest ports
      # is forwarded to the given host port.
      from = "host";

      # The host port to be mapped
      host.port = 7878;

      # The IPv4 address on the guest VLAN
      guest.port = 7878;
    }
  ];

  # Files and directories to persist across ephemeral boots
  environment.persistence."/persistent" = {
    # All directories you want to link or bind to persistent storage
    directories = [
      {
        directory = config.services.radarr.dataDir;
        user = "radarr";
        group = "radarr";
        mode = "0700";
      }
    ];
  };

  systemd.services.radarr-create-shows-directory = {
    # Description of this unit used in systemd messages and progress indicators
    description = "Radarr - Create Movies Directory";

    # If the specified units are started at the same time as this unit, delay this unit until they have started
    after = [ "mnt-media.mount" ];

    # Start the specified units when this unit is started, and stop this unit when the specified units are stopped or fail
    requires = [ "mnt-media.mount" ];

    # Units that want (i.e. depend on) this unit
    wantedBy = [ "multi-user.target" ];

    # Each attribute in this set specifies an option in the [Service] section of the unit
    serviceConfig = {
      type = "simple";
      ExecStart = getExe radarr-create-movies-directory;
    };
  };
}
