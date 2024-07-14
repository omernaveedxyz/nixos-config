{ config, ... }:
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
}
