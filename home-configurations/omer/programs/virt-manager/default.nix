{ pkgs, ... }:
{
  # The set of packages to appear in the user environment
  home.packages = with pkgs; [ virt-manager ];

  # Settings to write to the dconf configuration system
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}
