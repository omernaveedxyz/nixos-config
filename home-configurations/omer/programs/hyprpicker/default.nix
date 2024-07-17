{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkOptionDefault getExe;
in
{
  # The set of packages to appear in the user environment
  home.packages = with pkgs; [ hyprpicker ];

  wayland.windowManager.sway = mkIf (config.wayland.windowManager.sway.enable) {
    # Sway configuration options
    config = {
      # An attribute set that assigns a key press to an action using a key symbol
      keybindings = mkOptionDefault {
        "${config.wayland.windowManager.sway.config.modifier}+Shift+p" = "exec ${getExe pkgs.hyprpicker} --autocopy";
      };
    };
  };

  # An attribute set that assigns a key press to an action using a key symbol
  wayland.windowManager.hyprland = mkIf (config.wayland.windowManager.hyprland.enable) {
    settings.bind = [ "$Mod Shift, p, exec, ${getExe pkgs.hyprpicker} --autocopy" ];
  };
}
