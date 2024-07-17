{ config, ... }:
{
  services.jellyfin = {
    # Whether to enable Jellyfin Media Server
    enable = true;

    # Open the default ports in the firewall for the media server
    openFirewall = true;
  };

  # The user’s auxiliary groups
  users.users.jellyfin.extraGroups = [
    "sonarr"
    "radarr"
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
      host.port = 8096;

      # The IPv4 address on the guest VLAN
      guest.port = 8096;
    }
  ];

  # Files and directories to persist across ephemeral boots
  environment.persistence."/persistent" = {
    # All directories you want to link or bind to persistent storage
    directories = [
      {
        directory = config.services.jellyfin.dataDir;
        user = "jellyfin";
        group = "jellyfin";
        mode = "0755";
      }
    ];
  };
}
