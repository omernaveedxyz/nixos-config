{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  networking = {
    networkmanager = {
      # Whether to use NetworkManager to obtain an IP address and other
      # configuration for all network interfaces that are not manually
      # configured
      enable = true;

      wifi = {
        # Whether to enable MAC address randomization of a Wi-Fi device during
        # scanning
        scanRandMacAddress = true;

        # Set the MAC address of the interface
        macAddress = "random";
      };
    };

    # Enables DHCP on each ethernet and wireless interface. In case of scripted
    # networking (the default) this is the recommended approach. When using
    # systemd-networkd it's still possible to use this option, but it's
    # recommended to use it in conjunction with explicit per-interface
    # declarations with `networking.interfaces.<interface>.useDHCP`.
    useDHCP = mkDefault true;

    # Locally defined maps of hostnames to IP addresses
    hosts = {
      "10.0.0.2" = [ "omer-desktop" ];
      "10.0.0.3" = [ "omer-laptop" ];
    };
  };

  # Files and directories to persistent across ephemeral boots
  environment.persistence."/persistent" = {
    # All directories you want to link or bind to persistent storage
    directories = [
      {
        directory = "/etc/NetworkManager/system-connections";
        user = "root";
        group = "root";
        mode = "0700";
      }
    ];
  };
}
