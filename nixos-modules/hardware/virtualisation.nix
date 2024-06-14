{ pkgs, ... }:
{
  # This option enables libvirtd, a daemon that manages virtual machines
  virtualisation.libvirtd.enable = true;

  # Install the SPICE USB redirection helper with setuid privileges. This
  # allows unprivileged users to pass USB devices connected to this machine to
  # libvirt VMs, both local and remote. Note that this allows users arbitrary
  # access to USB devices
  virtualisation.spiceUSBRedirection.enable = true;

  # The set of packages that appear in /run/current-system/sw
  environment.systemPackages = with pkgs; [ virtiofsd ];

  # Files and directories to persistent across ephemeral boots
  environment.persistence."/persistent" = {
    # All directories you want to link or bind to persistent storage
    directories = [
      {
        directory = "/var/lib/libvirt";
        user = "root";
        group = "root";
        mode = "0700";
      }
    ];
  };
}
