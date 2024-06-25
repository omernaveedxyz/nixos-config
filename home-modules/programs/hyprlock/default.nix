{ config, lib, ... }:
let
  inherit (lib) mkIf getExe;
in
{
  programs.hyprlock = {
    # Whether to enable Hyprlock, Hyprland’s GPU-accelerated lock screen utility
    enable = config._module.args.desktop == "hyprland";
  };

  services.hypridle = mkIf (config.services.hypridle.enable) {
    # Hypridle configuration written in Nix
    settings = {
      # Variables in the general category
      general = {
        # command to run when receiving a dbus prepare_sleep event
        before_sleep_cmd = "${getExe config.programs.hyprlock.package}";
      };

      # Hypridle uses listeners to define actions on idleness
      listener = [
        {
          timeout = 600;
          on-timeout = "${getExe config.programs.hyprlock.package}";
        }
      ];
    };
  };

  # An attribute set that assigns a key press to an action using a key symbol
  wayland.windowManager.hyprland = mkIf (
    config.wayland.windowManager.hyprland.enable && config.programs.firefox.enable
  ) { settings.bind = [ "$Mod Shift, m, exec, ${getExe config.programs.hyprlock.package}" ]; };
}
