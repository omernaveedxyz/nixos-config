{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkOptionDefault getExe;
in
{
  services.clipman = {
    # Whether to enable clipman, a simple clipboard manager for Wayland
    enable = true;

    # The systemd target that will automatically start the clipman service
    systemdTarget = "${config._module.args.desktop}-session.target";
  };

  # The set of packages to appear in the user environment
  home.packages = with pkgs; [ wl-clipboard ];

  wayland.windowManager.sway = mkIf (config.wayland.windowManager.sway.enable)
      {
        # Sway configuration options
        config = {
          # An attribute set that assigns a key press to an action using a key symbol
          keybindings = mkOptionDefault {
            "${config.wayland.windowManager.sway.config.modifier}+Shift+u" = "exec ${getExe pkgs.clipman} pick -t rofi";
          };
        };
      };

  # An attribute set that assigns a key press to an action using a key symbol
  wayland.windowManager.hyprland = mkIf (config.wayland.windowManager.hyprland.enable) {
    settings.bind = [ "$Mod Shift, u, exec, ${getExe pkgs.clipman} pick -t rofi" ];
  };
}
