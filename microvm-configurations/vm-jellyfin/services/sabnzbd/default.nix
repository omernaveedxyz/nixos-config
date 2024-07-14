{
  services.sabnzbd = {
    # Whether to enable the sabnzbd server
    enable = true;

    # Open ports in the firewall for the sabnzbd web interface
    openFirewall = true;
  };

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
      host.port = 8080;

      # The IPv4 address on the guest VLAN
      guest.port = 8080;
    }
  ];

  # Files and directories to persist across ephemeral boots
  environment.persistence."/persistent" = {
    # All directories you want to link or bind to persistent storage
    directories = [
      {
        directory = "/var/lib/sabnzbd";
        user = "sabnzbd";
        group = "sabnzbd";
        mode = "0755";
      }
    ];
  };
}
