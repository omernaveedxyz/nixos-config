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
  programs.rofi = {
    # Whether to enable Rofi: A window switcher, application launcher and dmenu replacement
    enable = true;

    # Package providing the rofi binary
    package = pkgs.rofi-wayland;
  };

  # The set of packages to appear in the user environment
  home.packages = with pkgs; [ rofimoji ];

  wayland.windowManager.sway =
    mkIf (config.wayland.windowManager.sway.enable && config.programs.rofi.enable)
      {
        # Sway configuration options
        config = {
          # Default launcher to use
          menu = "${getExe config.programs.rofi.package} -show drun";

          # An attribute set that assigns a key press to an action using a key symbol
          keybindings = mkOptionDefault {
            "${config.wayland.windowManager.sway.config.modifier}+Shift+e" = "exec ${getExe pkgs.rofimoji} --action copy";
          };
        };
      };

  # An attribute set that assigns a key press to an action using a key symbol
  wayland.windowManager.hyprland = mkIf (config.wayland.windowManager.hyprland.enable && config.programs.rofi.enable) {
    settings.bind = [
      "$Mod, d, exec, ${getExe config.programs.rofi.package} -show drun"
      "$Mod Shift, e, exec, ${getExe pkgs.rofimoji} --action copy"
    ];
  };
}
