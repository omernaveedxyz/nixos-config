{ pkgs, ... }:
let
  mkVirtualHost =
    {
      locations ? { },
      root ? null,
    }:
    {
      # Whether to add a separate nginx server block that permanently redirects
      # (301) all plain HTTP traffic to HTTPS. This will set defaults for
      # listen to listen on all interfaces on the respective default ports
      # (80, 443), where the non-SSL listens are used for the redirect vhosts
      forceSSL = true;

      # Directory for the ACME challenge
      acmeRoot = null;

      # A host of an existing Let’s Encrypt certificate to use
      useACMEHost = "_omernaveed.dev";

      # Declarative location config
      inherit locations;

      # The path of the web root directory
      inherit root;
    };
in
{
  services.nginx = {
    # Whether to enable Nginx Web Server
    enable = true;

    # Enable recommended optimisation settings
    recommendedOptimisation = true;

    # Enable recommended gzip settings
    recommendedGzipSettings = true;

    # Enable recommended TLS settings
    recommendedTlsSettings = true;

    # Whether to enable recommended proxy settings if a vhost does not specify the option manually
    recommendedProxySettings = true;

    # Nginx package to use
    package = pkgs.nginxMainline.override { openssl = pkgs.libressl; };

    # Declarative vhost config
    virtualHosts = {
      "miniflux.omernaveed.dev" = mkVirtualHost {
        locations."/" = {
          proxyPass = "http://localhost:8234";
        };
      };
    };
  };

  # List of TCP ports on which incoming connections are accepted
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
