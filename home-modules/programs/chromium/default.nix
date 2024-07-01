{ config, lib, ... }:
let
  inherit (lib) mkIf getExe mkOptionDefault;
in
mkIf (config._module.args.browser == "chromium") {
  programs.chromium = {
    # Whether to enable Chromium
    enable = true;

    # List of Chromium extensions to install
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
    ];
  };

  # Environment variables to always set at login
  home.sessionVariables = {
    BROWSER = "${getExe config.programs.chromium.package}";
    PRIVATE_BROWSER = "${getExe config.programs.chromium.package} --incognito";
  };

  wayland.windowManager.sway = mkIf (config.wayland.windowManager.sway.enable) {
        # Sway configuration options
        config = {
          # An attribute set that assigns a key press to an action using a key symbol
          keybindings = mkOptionDefault {
            "${config.wayland.windowManager.sway.config.modifier}+Shift+b" = "exec ${config.home.sessionVariables.BROWSER}";
            "Ctrl+${config.wayland.windowManager.sway.config.modifier}+Shift+b" = "exec ${config.home.sessionVariables.PRIVATE_BROWSER}";
          };
        };
      };

  # An attribute set that assigns a key press to an action using a key symbol
  wayland.windowManager.hyprland = mkIf (config.wayland.windowManager.hyprland.enable) {
    settings.bind = [
      "$Mod Shift, b, exec, ${config.home.sessionVariables.BROWSER}"
      "Ctrl $Mod Shift, b, exec, ${config.home.sessionVariables.PRIVATE_BROWSER}"
    ];
  };
}
