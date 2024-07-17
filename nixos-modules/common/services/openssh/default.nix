{ config, lib, ... }:
let
  inherit (lib) mkIf;
in
{
  services.openssh = {
    # Whether to enable the OpenSSH secure shell daemon
    enable = true;

    # Systemd will start an intance for each incoming connection
    startWhenNeeded = true;

    # Whether to automatically open the specified ports in the firewall
    openFirewall = true;

    # Configuration for sshd_config(5)
    settings = {
      # Whether the root user can login using ssh
      PermitRootLogin = "no";

      # Specifies whether password authentication is allowed
      PasswordAuthentication = false;
    };
  };

  # Files and directories to persistent across ephemeral boots
  environment.persistence."/persistent" = mkIf (config._module.args.impermanence) {
    # All files you want to link or bind to persistent storage
    files = [
      {
        file = "/etc/ssh/ssh_host_ed25519_key";
        parentDirectory = {
          user = "root";
          group = "root";
          mode = "0755";
        };
      }
      {
        file = "/etc/ssh/ssh_host_ed25519_key.pub";
        parentDirectory = {
          user = "root";
          group = "root";
          mode = "0755";
        };
      }
      {
        file = "/etc/ssh/ssh_host_rsa_key";
        parentDirectory = {
          user = "root";
          group = "root";
          mode = "0755";
        };
      }
      {
        file = "/etc/ssh/ssh_host_rsa_key.pub";
        parentDirectory = {
          user = "root";
          group = "root";
          mode = "0755";
        };
      }
    ];
  };
}
