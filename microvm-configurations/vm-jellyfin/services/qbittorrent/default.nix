{ lib, pkgs, ... }:
let
  inherit (lib) getExe;

  update-qbittorrent-downloads-permission = pkgs.writeShellScriptBin "update-qbittorrent-downloads-permission" ''
    if [ "$(${pkgs.coreutils}/bin/stat -c %a /var/lib/qBittorrent/downloads)" != 2775 ]; then
      ${pkgs.coreutils}/bin/mkdir -p /var/lib/qBittorrent/downloads
      ${pkgs.coreutils}/bin/chown -R qbittorrent:qbittorrent /var/lib/qBittorrent/downloads
      ${pkgs.coreutils}/bin/chmod -R 0775 /var/lib/qBittorrent/downloads
      ${pkgs.acl}/bin/setfacl -R -d -m u::rwx,g::rwx,o::rx /var/lib/qBittorrent/downloads
      ${pkgs.coreutils}/bin/chmod -R g+s /var/lib/qBittorrent/downloads
    fi
  '';
in
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
          DefaultSavePath = "/var/lib/qBittorrent/downloads";
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
        directory = "/var/lib/qBittorrent";
        user = "qbittorrent";
        group = "qbittorrent";
        mode = "0755";
      }
    ];
  };

  systemd.services.qbittorrent-update-downloads-permission = {
    # Description of this unit used in systemd messages and progress indicators
    description = "qBittorrent - Update Downloads Permission";

    # If the specified units are started at the same time as this unit, delay this unit until they have started
    after = [ "qbittorrent.service" ];

    # Start the specified units when this unit is started, and stop this unit when the specified units are stopped or fail
    requires = [ "qbittorrent.service" ];

    # Units that want (i.e. depend on) this unit
    wantedBy = [ "multi-user.target" ];

    # Each attribute in this set specifies an option in the [Service] section of the unit
    serviceConfig = {
      type = "simple";
      ExecStart = getExe update-qbittorrent-downloads-permission;
    };
  };
}
