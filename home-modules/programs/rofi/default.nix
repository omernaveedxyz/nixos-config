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

    # List of rofi plugins to be installed
    plugins = with pkgs; [
      # REF: https://github.com/NixOS/nixpkgs/issues/298539
      (rofi-emoji.override {
        rofi-unwrapped = rofi-wayland-unwrapped;
      })
    ];

    # Name of theme or path to theme file in rasi format or attribute set with theme configuration
    theme = {}; # TODO: customize Rofi
  };

  # The set of packages to appear in the user environment
  home.packages = with pkgs; [ rofimoji ];

  wayland.windowManager.sway = mkIf (config.wayland.windowManager.sway.enable) {
        # Sway configuration options
        config = {
          # Default launcher to use
          menu = "${getExe config.programs.rofi.finalPackage} -show drun";

          # An attribute set that assigns a key press to an action using a key symbol
          keybindings = mkOptionDefault {
            "${config.wayland.windowManager.sway.config.modifier}+Shift+e" = "exec ${getExe config.programs.rofi.finalPackage} -modi emoji -show emoji";
          };
        };
      };

  # An attribute set that assigns a key press to an action using a key symbol
  wayland.windowManager.hyprland = mkIf (config.wayland.windowManager.hyprland.enable) {
    settings.bind = [
      "$Mod, d, exec, ${getExe config.programs.rofi.finalPackage} -show drun"
      "$Mod Shift, e, exec, ${getExe config.programs.rofi.finalPackage} -modi emoji -show emoji"
    ];
  };
}
