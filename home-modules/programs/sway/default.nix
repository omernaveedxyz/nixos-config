{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkOptionDefault getExe;
in
mkIf (config._module.args.desktop == "sway") {
  wayland.windowManager.sway = {
    # Whether to enable sway wayland compositor
    enable = true;

    # Sway configuration options
    config = {
      # Floating window settings
      floating = {
        # Floating windows border width
        border = 2;

        # Whether to show floating window titlebars
        titlebar = true;
      };

      # Focus related settings
      focus = {
        # Whether focus should follow the mouse
        followMouse = "yes";

        # Whether mouse cursor should be warped to the center of the window when switching focus to a window on a different output
        mouseWarping = "container";

        # This option modifies focus behavior on new window activation
        newWindow = "smart";

        # Whether the window focus commands automatically wrap around the edge of containers
        wrapping = "no";
      };

      # Gaps related settings
      gaps = {
        # Inner gaps value
        inner = 8;

	# Outer gaps value
	outer = 4;
      };

      # An attribute set that defines input modules
      input = {
        "type:keyboard" = {
          # Sets the frequency of key repeats once the repeat_delay has passed
          repeat_rate = "50";

          # Sets the amount of time a key must be held before it starts repeating
          repeat_delay = "300";
        };

        "type:touchpad" = {
          # Enables or disables tap for specified input device
          tap = "enabled";

          # Enables or disables natural (inverted) scrolling for the specified input device
          natural_scroll = "enabled";
        };
      };

      # An attribute set that assigns a key press to an action using a key symbol
      keybindings = mkOptionDefault {
        "XF86MonBrightnessDown" = "exec ${getExe pkgs.brightnessctl} set 5%- | sed -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > /run/user/1000/wob.sock";
        "XF86MonBrightnessUp" = "exec ${getExe pkgs.brightnessctl} set 5%+ | sed -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > /run/user/1000/wob.sock";
        "Shift+XF86MonBrightnessDown" = "exec ${getExe pkgs.brightnessctl} set 1%- | sed -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > /run/user/1000/wob.sock";
        "Shift+XF86MonBrightnessUp" = "exec ${getExe pkgs.brightnessctl} set 1%+ | sed -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > /run/user/1000/wob.sock";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+XF86MonBrightnessDown" = "exec ${getExe pkgs.brightnessctl} set 0% | sed -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > /run/user/1000/wob.sock";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+XF86MonBrightnessUp" = "exec ${getExe pkgs.brightnessctl} set 100% | sed -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > /run/user/1000/wob.sock";

        "XF86AudioLowerVolume" = "exec ${getExe pkgs.pamixer} --decrease 5 && ${getExe pkgs.pamixer} --get-volume > /run/user/1000/wob.sock";
        "XF86AudioRaiseVolume" = "exec ${getExe pkgs.pamixer} --increase 5 && ${getExe pkgs.pamixer} --get-volume > /run/user/1000/wob.sock";
        "Shift+XF86AudioLowerVolume" = "exec ${getExe pkgs.pamixer} --decrease 1 && ${getExe pkgs.pamixer} --get-volume > /run/user/1000/wob.sock";
        "Shift+XF86AudioRaiseVolume" = "exec ${getExe pkgs.pamixer} --increase 1 && ${getExe pkgs.pamixer} --get-volume > /run/user/1000/wob.sock";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+XF86AudioLowerVolume" = "exec ${getExe pkgs.pamixer} --set-volume 0 && ${getExe pkgs.pamixer} --get-volume > /run/user/1000/wob.sock";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+XF86AudioRaiseVolume" = "exec ${getExe pkgs.pamixer} --set-volume 100 && ${getExe pkgs.pamixer} --get-volume > /run/user/1000/wob.sock";
        "XF86AudioMute" = "exec ${getExe pkgs.pamixer} --toggle-mute && ( [ \"$(${getExe pkgs.pamixer} --get-mute)\" = \"true\" ] && echo 0 > /run/user/1000/wob.sock ) || ${getExe pkgs.pamixer} --get-volume > /run/user/1000/wob.sock";

        "${config.wayland.windowManager.sway.config.modifier}+Shift+v" = "exec ${pkgs.libnotify}/bin/notify-send 'Starting VPN' && sudo ${pkgs.systemd}/bin/systemctl start wg-quick-wg0.service";
        "${config.wayland.windowManager.sway.config.modifier}+v" = "exec ${pkgs.libnotify}/bin/notify-send 'Stopping VPN' && sudo ${pkgs.systemd}/bin/systemctl stop wg-quick-wg0.service";

        "${config.wayland.windowManager.sway.config.modifier}+Shift+b" = "exec ${config.home.sessionVariables.BROWSER}";
        "Ctrl+${config.wayland.windowManager.sway.config.modifier}+Shift+b" = "exec ${config.home.sessionVariables.PRIVATE_BROWSER}";
      };

      # Modifier key that is used for all default keybindings
      modifier = "Mod1";

      # Window titlebar and border settings
      window = {
        # Window border width
        border = 2;

        # List of commands that should be executed on specific windows
        commands = [ ];

        # Hide window borders adjacent to the screen edges
        hideEdgeBorders = "none";

        # Whether to show window titlebars
        titlebar = true;
      };
    };

    swaynag = {
      # Whether to enable configuration of swaynag, a lightweight error bar for sway
      enable = true;
    };

    systemd = {
      # Whether to enable sway-session.target on sway startup
      enable = true;
    };

    # Enable xwayland, which is needed for the default configuration of sway
    xwayland = true;
  };
}
