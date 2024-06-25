{ config, lib, ... }:
let
  inherit (lib) mkIf getExe;
in
{
  programs.hyprlock = {
    # Whether to enable Hyprlock, Hyprland’s GPU-accelerated lock screen utility
    enable = config._module.args.desktop == "hyprland";

    # Hyprlock configuration written in Nix
    settings = {
      # Variables in the general category
      general = {
        # Disables the loading bar on the bottom of the screen while hyprlock is booting up
        disable_loading_bar = false;

        # Hides the cursor instead of making it visible
        hide_cursor = false;

        # The amount of seconds for which the lockscreen will unlock on mouse movement
        grace = 0;

        # Disables the fadein animation
        no_fade_in = false;

        # Disables the fadeout animation
        no_fade_out = false;

        # Skips validation when no password is provided
        ignore_empty_input = true;
      };

      # Draws a background image or fills with color
      background = [ { path = "${config.stylix.image}"; } ];

      # Draws a password input field
      input-field = [
        {
          size = "600, 50";
          position = "0, -150";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text = "<span foreground=\"##cad3f5\">Password...</span>";
          shadow_passes = 2;
        }
      ];
    };
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
