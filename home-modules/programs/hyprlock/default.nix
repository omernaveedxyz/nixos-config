{ config, lib, ... }:
let
  inherit (lib) mkIf getExe;
in
mkIf (config.wayland.windowManager.hyprland.enable) {
  programs.hyprlock = {
    # Whether to enable Hyprlock, Hyprland’s GPU-accelerated lock screen utility
    enable = true;

    # Hyprlock configuration written in Nix
    settings = {
      # Variables in the general category
      general = {
        # Skips validation when no password is provided
        ignore_empty_input = true;
      };

      # Draws a background image or fills with color
      background = [
        {
          path = "${config.stylix.image}";
          blur_passes = 3;
        }
      ];

      # Draws a password input field
      input-field = [
        {
          monitor = "";
          size = "250, 60";
          outline_thickness = 2;
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          outer_color = "rgba(0, 0, 0, 0)";
          inner_color = "rgba(0, 0, 0, 0.75)";
          font_color = "rgb(200, 200, 200)";
          fade_on_empty = false;
          font_family = "${config.stylix.fonts.sansSerif.name} Bold";
          placeholder_text = "<i><span foreground=\"##cdd6f4\">Enter Password</span></i>";
          hide_input = false;
          position = "0, -120";
          halign = "center";
          valign = "center";
        }
      ];

      # Draws a label
      label = [
        {
          monitor = "";
          text = "cmd[update:1000] echo \"$(date +\"%H:%M\")\"";
          color = "rgba(255, 255, 255, 0.6)";
          font_size = "120";
          font_family = "${config.stylix.fonts.sansSerif.name} Bold";
          position = "0, -300";
          halign = "center";
          valign = "top";
        }
        {
          monitor = "";
          text = "cmd[update:1000] echo \"$(date +\"%A %B %d, %Y\")\"";
          color = "rgba(255, 255, 255, 0.6)";
          font_size = "24";
          font_family = "${config.stylix.fonts.sansSerif.name} Bold";
          position = "0, -500";
          halign = "center";
          valign = "top";
        }
      ];
    };
  };

  # An attribute set that assigns a key press to an action using a key symbol
  wayland.windowManager.hyprland = {
    settings.bind = [ "$Mod Shift, m, exec, ${getExe config.programs.hyprlock.package}" ];
  };
}
