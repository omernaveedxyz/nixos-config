{ config, lib, ... }:
let
  inherit (lib) toInt;
in
{
  services.miniflux = {
    # Whether to enable miniflux
    enable = true;

    # Whether a PostgreSQL database should be automatically created and configured on the local host
    createDatabaseLocally = true;

    # File containing the ADMIN_USERNAME and ADMIN_PASSWORD (length >= 6) in the format of an EnvironmentFile=, as described by systemd.exec(5)
    adminCredentialsFile = config.sops.secrets."services/miniflux/adminCredentialsFile".path;

    # Configuration for Miniflux
    config = {
      # Set the value to 1 to scrape video duration from YouTube website and use it as a reading time
      FETCH_YOUTUBE_WATCH_TIME = "1";

      # Number of background workers to refresh feeds. Workers fetch information of feeds from a work queue
      WORKER_POOL_SIZE = "12";

      # The interval in minutes that miniflux adds qualified feeds to the work queue
      POLLING_FREQUENCY = "5";

      # Override LISTEN_ADDR to 0.0.0.0:$PORT (Automatic configuration for PaaS)
      PORT = "8234";

      # Base URL to generate HTML links and base path for cookies
      BASE_URL = "https://miniflux.omernaveed.dev";
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

      # the host port to be mapped
      host.port = toInt config.services.miniflux.config.PORT;

      # the IPv4 address on the guest VLAN
      guest.port = toInt config.services.miniflux.config.PORT;
    }
  ];

  # List of TCP ports on which incoming connections are accepted
  networking.firewall.allowedTCPPorts = [ (toInt config.services.miniflux.config.PORT) ];

  # Specify encrypted sops secret to access
  sops.secrets."services/miniflux/adminCredentialsFile" = {
    sopsFile = ../../secrets.yaml;
  };
}
