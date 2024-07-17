{ config, lib, ... }:
let
  inherit (lib) mkIf;
in
{
  security.acme = {
    # Accept the CA's terms of service
    acceptTerms = true;

    # Default values inheritable by all configured certs.
    defaults = {
      # Email address for account creation and correspondence from the CA.
      email = "acme.theater443@passmail.net";

      # DNS Challenge provider
      dnsProvider = "cloudflare";

      # Path to an EnvironmentFile for the cert’s service containing any required and optional environment variables for your selected dnsProvider
      environmentFile = config.sops.secrets."security/acme/default/environmentFile".path;
    };

    # Attribute set of certificates to get signed and renewed
    certs = {
      "_omernaveed.dev" = {
        # Domain to fetch certificate for (defaults to the entry name)
        domain = "*.omernaveed.dev";
      };
    };
  };

  # The user’s auxiliary groups
  users.users."nginx".extraGroups = [ "acme" ];

  # Files and directories to persist across ephemeral boots
  environment.persistence."/persistent" = mkIf (config._module.args.impermanence) {
    # All directories you want to link or bind to persistent storage
    directories = [
      {
        directory = "/var/lib/acme";
        user = "acme";
        group = "acme";
        mode = "0755";
      }
    ];
  };

  # Specify encrypted sops secret to access
  sops.secrets."security/acme/default/environmentFile" = {
    sopsFile = ../../secrets.yaml;
    owner = "acme";
    group = "acme";
  };
}
