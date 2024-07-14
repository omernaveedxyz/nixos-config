{ config, ... }:
{
  services.sonarr = {
    # Whether to enable Sonarr
    enable = true;

    # Open ports in the firewall for the Sonarr web interface
    openFirewall = true;
  };

  # The user’s auxiliary groups
  users.users.sonarr.extraGroups = [
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
      host.port = 8989;

      # The IPv4 address on the guest VLAN
      guest.port = 8989;
    }
  ];

  # Files and directories to persist across ephemeral boots
  environment.persistence."/persistent" = {
    # All directories you want to link or bind to persistent storage
    directories = [
      {
        directory = config.services.sonarr.dataDir;
        user = "sonarr";
        group = "sonarr";
        mode = "0700";
      }
    ];
  };
}
