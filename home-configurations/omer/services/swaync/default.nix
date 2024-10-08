{ config, lib, ... }:
let
  inherit (lib) mkIf mkOptionDefault getExe;
in
{
  services.swaync = {
    # Whether to enable Swaync notification daemon
    enable = true;

    # TODO: Customize SwayNC
    # Configuration written to $XDG_CONFIG_HOME/swaync/config.json
    # settings = { };

    # CSS style of the bar
    # style = ''
    # '';
  };

  wayland.windowManager.sway = mkIf (config.wayland.windowManager.sway.enable) {
    # Sway configuration options
    config = {
      # An attribute set that assigns a key press to an action using a key symbol
      keybindings = mkOptionDefault {
        "${config.wayland.windowManager.sway.config.modifier}+Shift+n" = "exec ${getExe config.services.swaync.package}-client -t -sw";
      };
    };
  };

  # An attribute set that assigns a key press to an action using a key symbol
  wayland.windowManager.hyprland = mkIf (config.wayland.windowManager.hyprland.enable) {
    settings.bind = [ "$Mod Shift, n, exec, ${getExe config.services.swaync.package}-client -t -sw" ];
  };
}
