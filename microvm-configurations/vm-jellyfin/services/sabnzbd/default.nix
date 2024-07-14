{ lib, pkgs, ... }:
let
  inherit (lib) getExe;

  update-sabnzbd-whitelist = pkgs.writeShellScriptBin "update-sabnzbd-whitelist" ''
    if [ -f /var/lib/sabnzbd/sabnzbd.ini ]; then
      if ! ${getExe pkgs.gnugrep} -Fxq "host = 0.0.0.0" /var/lib/sabnzbd/sabnzbd.ini || ! ${getExe pkgs.gnugrep} -Fxq "host_whitelist = sabnzbd.omernaveed.dev" /var/lib/sabnzbd/sabnzbd.ini; then
        ${getExe pkgs.gnused} -i 's/host = .*/host = 0.0.0.0/' /var/lib/sabnzbd/sabnzbd.ini
        ${getExe pkgs.gnused} -i 's/host_whitelist = .*/host_whitelist = sabnzbd.omernaveed.dev/' /var/lib/sabnzbd/sabnzbd.ini
        ${pkgs.systemd}/bin/systemctl restart sabnzbd.service
      fi
    fi
  '';

  update-sabnzbd-downloads-permission = pkgs.writeShellScriptBin "update-sabnzbd-downloads-permission" ''
    if [ "$(${pkgs.coreutils}/bin/stat -c %a /var/lib/sabnzbd/Downloads)" != 2775 ]; then
      ${pkgs.coreutils}/bin/mkdir -p /var/lib/sabnzbd/Downloads
      ${pkgs.coreutils}/bin/chown -R sabnzbd:sabnzbd /var/lib/sabnzbd/Downloads
      ${pkgs.coreutils}/bin/chmod -R 0775 /var/lib/sabnzbd/Downloads
      ${pkgs.acl}/bin/setfacl -R -d -m u::rwx,g::rwx,o::rx /var/lib/sabnzbd/Downloads
      ${pkgs.coreutils}/bin/chmod -R g+s /var/lib/sabnzbd/Downloads
    fi
  '';
in
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

  systemd.services.sabnzbd-update-downloads-permission = {
    # Description of this unit used in systemd messages and progress indicators
    description = "SABnzbd - Update Downloads Permission";

    # If the specified units are started at the same time as this unit, delay this unit until they have started
    after = [ "sabnzbd.service" ];

    # Start the specified units when this unit is started, and stop this unit when the specified units are stopped or fail
    requires = [ "sabnzbd.service" ];

    # Units that want (i.e. depend on) this unit
    wantedBy = [ "multi-user.target" ];

    # Each attribute in this set specifies an option in the [Service] section of the unit
    serviceConfig = {
      type = "simple";
      ExecStart = getExe update-sabnzbd-downloads-permission;
    };
  };

  systemd.services.sabnzbd-update-whitelist = {
    # Description of this unit used in systemd messages and progress indicators
    description = "SABnzbd - Update Whitelist";

    # If the specified units are started at the same time as this unit, delay this unit until they have started
    after = [ "sabnzbd.service" ];

    # Start the specified units when this unit is started, and stop this unit when the specified units are stopped or fail
    requires = [ "sabnzbd.service" ];

    # Units that want (i.e. depend on) this unit
    wantedBy = [ "multi-user.target" ];

    # Each attribute in this set specifies an option in the [Service] section of the unit
    serviceConfig = {
      type = "simple";
      ExecStart = getExe update-sabnzbd-whitelist;
    };
  };
}
