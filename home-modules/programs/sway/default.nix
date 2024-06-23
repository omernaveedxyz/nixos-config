{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOptionDefault getExe;
in
{
  wayland.windowManager.sway = {
    # Whether to enable sway wayland compositor
    enable = config._module.args.desktop == "sway";

    # Sway configuration options
    config = {
      # An attribute set that assigns applications to workspaces based on criteria
      assigns = { };

      # Sway bars settings blocks
      bars = [ ];

      # Whether to make use of --to-code in keybindings
      bindkeysToCode = false;

      # Floating window settings
      floating = {
        # Floating windows border width
        border = 2;

        # List of criteria for windows that should be opened in a floating mode
        criteria = [ ];

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
        # Bottom gaps value
        bottom = null;

        # Horizontal gaps value
        horizontal = null;

        # Inner gaps value
        inner = 12;

        # Left gaps value
        left = null;

        # Outer gaps value
        outer = null;

        # Right gaps value
        right = null;

        # This option controls whether to disable container borders on workspace with a single container
        smartBorders = "off";

        # This option controls whether to disable all gaps (outer and inner) on workspace with a single container
        smartGaps = false;

        # Top gaps value
        top = null;

        # Vertical gaps value
        vertical = null;
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
        "XF86MonBrightnessDown" = "exec ${getExe pkgs.brightnessctl} set 5%-";
        "XF86MonBrightnessUp" = "exec ${getExe pkgs.brightnessctl} set 5%+";
        "Shift+XF86MonBrightnessDown" = "exec ${getExe pkgs.brightnessctl} set 1%-";
        "Shift+XF86MonBrightnessUp" = "exec ${getExe pkgs.brightnessctl} set 1%+";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+XF86MonBrightnessDown" = "exec ${getExe pkgs.brightnessctl} set 0%";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+XF86MonBrightnessUp" = "exec ${getExe pkgs.brightnessctl} set 100%";

        "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "Shift+XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -1%";
        "Shift+XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +1%";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ 0%";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ 100%";
        "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";

        "${config.wayland.windowManager.sway.config.modifier}+Shift+v" = "exec ${pkgs.libnotify}/bin/notify-send 'Starting VPN' && sudo ${pkgs.systemd}/bin/systemctl start wg-quick-wg0.service";
        "${config.wayland.windowManager.sway.config.modifier}+v" = "exec ${pkgs.libnotify}/bin/notify-send 'Stopping VPN' && sudo ${pkgs.systemd}/bin/systemctl stop wg-quick-wg0.service";
      };

      # An attribute set that assigns keypress to an action using key code
      keycodebindings = { };

      # Modifier key that is used for all default keybindings
      modifier = "Mod1";

      # An attribute set that defines output modules
      output = { };

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

      # Assume you are on workspace “1: www” and switch to “2: IM” using mod+2
      # because somebody sent you a message. You don’t need to remember where
      # you came from now, you can just press $mod+2 again to switch back to “1: www”
      workspaceAutoBackAndForth = false;

      # The mode in which new containers on workspace level will start
      workspaceLayout = "default";

      # Assign workspaces to outputs
      workspaceOutputAssign = [ ];
    };

    # Like extraConfig, except lines are added to ~/.config/sway/config before all other configuration
    extraConfigEarly = "";

    # Command line arguments passed to launch Sway
    extraOptions = [ ];

    # Shell commands executed just before Sway is started
    extraSessionCommands = "";

    swaynag = {
      # Whether to enable configuration of swaynag, a lightweight error bar for sway
      enable = true;

      # Configuration written to $XDG_CONFIG_HOME/swaynag/config
      settings = { };
    };

    systemd = {
      # Whether to enable sway-session.target on sway startup
      enable = true;

      # Whether to enable autostart of applications using systemd-xdg-autostart-generator(8)
      xdgAutostart = false;
    };

    # Attribute set of features to enable in the wrapper
    wrapperFeatures = {
      # Whether to make use of the base wrapper to execute extra session commands and prepend a dbus-run-session to the sway command
      base = true;

      # Whether to make use of the wrapGAppsHook wrapper to execute sway with required environment variables for GTK applications
      gtk = false;
    };

    # Enable xwayland, which is needed for the default configuration of sway
    xwayland = true;
  };
}
