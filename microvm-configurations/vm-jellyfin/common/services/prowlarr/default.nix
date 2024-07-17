{
  services.prowlarr = {
    # Whether to enable Prowlarr
    enable = true;

    # Open ports in the firewall for the Prowlarr web interface
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
      host.port = 9696;

      # The IPv4 address on the guest VLAN
      guest.port = 9696;
    }
  ];

  # Files and directories to persist across ephemeral boots
  environment.persistence."/persistent" = {
    # All directories you want to link or bind to persistent storage
    directories = [
      {
        directory = "/var/lib/private/prowlarr";
        user = "prowlarr";
        group = "prowlarr";
        mode = "0755";
      }
    ];
  };
}
