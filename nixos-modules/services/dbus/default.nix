{ pkgs, ... }:
{
  # Packages whose D-Bus configuration files should be included in the 
  # configuration of the D-Bus system-wide or session-wide message bus
  services.dbus.packages = [ pkgs.gcr ];
}
