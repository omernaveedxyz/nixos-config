{ config, lib, ... }:
let
  inherit (lib) mkIf mkOptionDefault getExe;
in
{
  services.swaync = {
    # Whether to enable Swaync notification daemon
    enable = true;
  };

  wayland.windowManager.sway =
    mkIf (config.wayland.windowManager.sway.enable && config.services.swaync.enable)
      {
        # Sway configuration options
        config = {
          # An attribute set that assigns a key press to an action using a key symbol
          keybindings = mkOptionDefault {
            "${config.wayland.windowManager.sway.config.modifier}+Shift+n" = "exec ${getExe config.services.swaync.package}-client -t -sw";
          };
        };
      };

  # An attribute set that assigns a key press to an action using a key symbol
  wayland.windowManager.hyprland =
    mkIf (config.wayland.windowManager.hyprland.enable && config.services.swaync.enable)
      {
        settings.bind = [ "$Mod Shift, n, exec, ${getExe config.services.swaync.package}-client -t -sw" ];
      };
}
