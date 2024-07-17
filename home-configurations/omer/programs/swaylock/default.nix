{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkOptionDefault getExe;
in
mkIf (config.wayland.windowManager.sway.enable) {
  programs.swaylock = {
    # Whether to enable swaylock
    enable = true;

    # The swaylock package to use
    package = pkgs.swaylock-effects;

    # Default arguments to swaylock
    settings = {
      # Sets the indicator to show even if idle
      indicator-idle-visible = true;

      # Sets the indicator radius
      indicator-radius = 120;

      # Show a clock in the indicator
      clock = true;
    };
  };

  wayland.windowManager.sway = {
    # Sway configuration options
    config = {
      # An attribute set that assigns a key press to an action using a key symbol
      keybindings = mkOptionDefault {
        "${config.wayland.windowManager.sway.config.modifier}+Shift+m" = "exec ${getExe config.programs.swaylock.package} -fF";
      };
    };
  };
}
