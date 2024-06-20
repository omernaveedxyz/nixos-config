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
  programs.lf = {
    # Whether to enable lf
    enable = true;
  };

  wayland.windowManager.sway = mkIf (config.wayland.windowManager.sway.enable) {
    # Sway configuration options
    config = {
      # An attribute set that assigns a key press to an action using a key symbol
      keybindings = mkOptionDefault {
        "${config.wayland.windowManager.sway.config.modifier}+Shift+f" = "exec ${getExe config.programs.foot.package} -e lf";
      };
    };
  };
}
