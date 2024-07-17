{ config, lib, ... }:
let
  inherit (lib) getExe;
in
{
  services.swayidle = {
    # Whether to enable idle manager for Wayland
    enable = config.wayland.windowManager.sway.enable;

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
