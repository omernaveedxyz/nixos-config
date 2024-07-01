{ config, lib, ... }: let
  inherit (lib) getExe;
in {
  services.hypridle = {
    # Whether to enable Hypridle, Hyprland’s idle daemon
    enable = config._module.args.desktop == "hyprland";

    #
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
}
