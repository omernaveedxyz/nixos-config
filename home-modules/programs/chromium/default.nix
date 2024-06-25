{ config, lib, ... }:
let
  inherit (lib) getExe mkIf mkOptionDefault;
in
{
  programs.chromium = {
    # Whether to enable Chromium
    enable = config._module.args.browser == "chromium";

    # List of Chromium extensions to install
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
    ];
  };

  # Environment variables to always set at login
  home.sessionVariables = mkIf (config.programs.chromium.enable) {
    BROWSER = "${getExe config.programs.firefox.package}";
  };

  wayland.windowManager.sway =
    mkIf (config.wayland.windowManager.sway.enable && config.programs.chromium.enable)
      {
        # Sway configuration options
        config = {
          # An attribute set that assigns a key press to an action using a key symbol
          keybindings = mkOptionDefault {
            "${config.wayland.windowManager.sway.config.modifier}+Shift+b" = "exec ${getExe config.programs.chromium.package}";
          };
        };
      };

  # An attribute set that assigns a key press to an action using a key symbol
  wayland.windowManager.hyprland = mkIf (
    config.wayland.windowManager.hyprland.enable && config.programs.chromium.enable
  ) { settings.bind = [ "$Mod Shift, b, exec, ${getExe config.programs.chromium.package}" ]; };
}
