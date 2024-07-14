{
  services.qbittorrent = {
    # Whether to enable qbittorrent
    enable = true;

    # Opening both the webuiPort and torrentPort over TCP in the firewall
    openFirewall = true;

    # The port passed to qbittorrent via `--webui-port`
    webuiPort = 8282;

    # Free-form settings mapped to the `qBittorrent.conf`
    serverConfig = {
      Preferences = {
        WebUI = {
          Username = "omernaveedxyz";
          Password_PBKDF2 = "@ByteArray(+Wt9OCJf6KMbP/u5O/4m7g==:kCUp8wZACHVFM7XjhRnA6MD2e10rtBAqvuKxpC725IHpHHiRIsMJXvsOOv/0c2hLIRQWpikkl/aEz/gbYOw7fQ==)";
        };
      };
      BitTorrent = {
        Session = {
          GlobalMaxRatio = 0;
        };
      };
    };
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
      host.port = 8282;

      # The IPv4 address on the guest VLAN
      guest.port = 8282;
    }
  ];

  # Files and directories to persist across ephemeral boots
  environment.persistence."/persistent" = {
    # All directories you want to link or bind to persistent storage
    directories = [
      {
        directory = "/var/lib/qBittorrent/qBittorrent";
        user = "qbittorrent";
        group = "qbittorrent";
        mode = "0755";
      }
    ];
  };
}
