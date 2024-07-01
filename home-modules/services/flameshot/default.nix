{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe mkIf mkOptionDefault;

  screenshot = pkgs.writeShellScriptBin "screenshot" ''
    year=$(${pkgs.coreutils}/bin/date +"%Y")
    month=$(${pkgs.coreutils}/bin/date +"%m")

    filepath=(${config.xdg.userDirs.pictures}/$year/$month)

    ${pkgs.coreutils}/bin/mkdir -p $filepath

    if [ "$1" == "full" ]; then
    	${getExe config.services.flameshot.package} full -p $filepath
    elif [ "$1" == "gui" ]; then
    	${getExe config.services.flameshot.package} gui -p $filepath
    fi
  '';
in
{
  services.flameshot = {
    # Whether to enable Flameshot
    enable = true;

    # Configuration to use for Flameshot
    settings = {
      General = {
        autoCloseIdleDaemon = true;
        checkForUpdates = false;
        contrastOpacity = 191;
        disabledTrayIcon = true;
        filenamePattern = "Screenshot_%Y%m%d_%H%M%S";
        savePath = "${config.xdg.userDirs.pictures}";
        savePathFixed = true;
        showDesktopNotification = true;
        showHelp = false;
        showStartupLaunchMessage = false;
        useJpgForClipboard = true;
      };
    };
  };

  # The set of packages to appear in the user environment
  home.packages = with pkgs; [ grim ];

  wayland.windowManager.sway = mkIf (config.wayland.windowManager.sway.enable) {
    # Sway configuration options
    config = {
      # An attribute set that assigns a key press to an action using a key symbol
      keybindings = mkOptionDefault {
        "Print" = "exec ${getExe screenshot} gui";
        "Shift+Print" = "exec ${getExe screenshot} full";
      };

      # List of commands that should be executed on specific windows
      window.commands = [
        {
          # Swaywm command to execute
          command = "border pixel 0, floating enable, fullscreen disable, move absolute position 0";

          # Criteria of the windows on which command should be executed
          criteria = {
            app_id = "flameshot";
          };
        }
      ];

      # Commands that should be executed at startup
      startup = [
        {
          # Commands that should be executed at startup
          command = "systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK";

          # Commands that should be executed at startup
          always = true;
        }
        {
          # Commands that should be executed at startup
          command = "hash dbus-update-activation-environment 2>/dev/null && dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK";

          # Commands that should be executed at startup
          always = true;
        }
      ];
    };
  };

  # Hyprland configuration written in Nix
  wayland.windowManager.hyprland = mkIf (config.wayland.windowManager.hyprland.enable) {
    settings = {
      bind = [
        ", Print, exec, ${getExe screenshot} gui"
        "Shift, Print, exec, ${getExe screenshot} full"
      ];

      windowrulev2 = [
        "float, title:^(flameshot)"
        "center, title:^(flameshot)"
      ];
    };
  };

  # Environment variables to always set at login
  home.sessionVariables = {
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    QT_QPA_PLATFORM = "wayland";
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_DESKTOP = "sway";
  };
}
