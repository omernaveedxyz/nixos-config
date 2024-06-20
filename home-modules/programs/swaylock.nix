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

  wayland.windowManager.sway = mkIf (config.wayland.windowManager.sway.enable) {
    # Sway configuration options
    config = {
      # An attribute set that assigns a key press to an action using a key symbol
      keybindings = mkOptionDefault {
        "${config.wayland.windowManager.sway.config.modifier}+Shift+m" = "exec ${getExe config.programs.swaylock.package} -fF";
      };
    };
  };

  services.swayidle = mkIf (config.services.swayidle.enable) {
    # Run command on occurrence of a event
    events = [
      {
        event = "before-sleep";
        command = "${getExe config.programs.swaylock.package} -fF";
      }
    ];

    # List of commands to run after idle timeout
    timeouts = [
      {
        timeout = 600;
        command = "${getExe config.programs.swaylock.package} -fF";
      }
    ];
  };
}
