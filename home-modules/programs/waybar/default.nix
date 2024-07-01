{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe mkIf;

  waybar-module-custom-uptime = pkgs.writeShellScriptBin "waybar-module-custom-uptime" ''
    ${getExe pkgs.gawk} '{m=$1/60;h=m/60;printf "%sd %sh %sm",int(h/24),int(h%24),int(m%60)}' /proc/uptime
  '';
in
{
  programs.waybar = {
    # Whether to enable Waybar
    enable = true;

    # Configuration for Waybar
    settings = [
      {
        # Decide if the bar is displayed in front (top) of the windows or behind (bottom) them
        layer = "bottom";

        # Bar position, can be top,bottom,left,right
        position = "top";

        # Height to be used by the bar if possible, leave blank for a dynamic value
        height = 32;

        # Modules that will be displayed on the left
        modules-left = [
          "${config._module.args.desktop}/workspaces"
          "${config._module.args.desktop}/window"
        ];

        # Modules that will be displayed in the center
        modules-center = [ "clock" ];

        # Modules that will be displayed on the right
        modules-right = [
          "idle_inhibitor"
          "custom/uptime"
          "backlight"
          "pulseaudio"
          "custom/disk"
          "memory"
          "cpu"
          "battery"
          "custom/notifications"
        ];

        # Size of gaps in between of the different modules
        spacing = 4;

        # The workspaces module displays the current active workspaces in your Wayland compositor
        "sway/workspaces" = {
          # The format, how information should be displayed
          format = "{icon}";

          # If set to false workspaces group will be shown only in assigned output. Otherwise all workspace groups are shown
          all-outputs = false;

          # Based on the workspace name and state, the corresponding icon gets selected
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "0";
          };
        };

        # The workspaces module displays the currently used workspaces in hyprland compositor
        "hyprland/workspaces" = {
          # The format, how information should be displayed
          format = "{icon}";

          # If set to false workspaces group will be shown only in assigned output. Otherwise all workspace groups are shown
          all-outputs = false;

          # Based on the workspace name and state, the corresponding icon gets selected
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "0";
          };
        };

        # The window module displays the title of the currently focused window in sway
        "sway/window" = {
          # The format, how information should be displayed
          format = "";
        };

        # The window module displays the title of the currently focused window of Hyprland
        "hyprland/window" = {
          # The format, how information should be displayed
          format = "";
        };

        # The clock module displays the current date and time
        "clock" = {
          # The interval in which the information gets polled
          interval = 15;

          # The format, how the date and time should be displayed
          format = "{:%a %b %d %H:%M}";
        };

        # The idle_inhibitor module can inhibit idle behavior such as screen blanking, 
        # locking, and screensaving, also known as "presentation mode"
        "idle_inhibitor" = {
          # The format, how the state should be displayed
          format = "{status} {icon}";

          # Based on the current state, the corresponding icon gets selected
          format-icons = {
            "activated" = "  ";
            "deactivated" = "  ";
          };
        };

        # The uptime module displays the total uptime of the system
        "custom/uptime" = {
          # The path to a script which executes and outputs
          exec = "${waybar-module-custom-uptime}/bin/waybar-module-custom-uptime";

          # The format, how information should be displayed
          format = "{}   ";

          # The interval (in seconds) in which the information gets polled
          interval = 60;
        };

        # The backlight module displays the current backlight level
        "backlight" = {
          # The format, how information should be displayed
          format = "{percent}% {icon}";

          # Based on the current backlight value, the corresponding icon gets selected
          format-icons = [
            " "
            " "
            " "
            " "
            " "
            " "
            " "
            " "
            " "
          ];

          # Option to enable tooltip on hover
          tooltip = false;
        };

        # The pulseaudio module displays the current volume reported by pulseaudio
        "pulseaudio" = {
          # The format, how information should be displayed
          format = "{volume}% {icon}";

          # This format is used when the sound is muted
          format-muted = "{volume}%  ";

          # Based on the current port-name and volume, the corresponding icon 
          # gets selected
          format-icons = {
            default = [
              " "
              " "
            ];
          };

          # Command to execute when clicked on the module
          on-click = "${config.home.sessionVariables.TERMINAL} --title ncpamixer -e ${getExe pkgs.ncpamixer}";
        };

        # The disk module tracks the usage of filesystems and partitions
        "custom/disk" = {
          # The path to a script which executes and outputs
          exec = "${pkgs.zfs}/bin/zpool list -H $(${pkgs.nettools}/bin/hostname) | ${getExe pkgs.gawk} '{print $3 \"iB / \" $2 \"iB 󱛟 \"}'";

          # Command to execute when clicked on the module
          on-click = "${config.home.sessionVariables.TERMINAL} --title bashmount -e ${getExe pkgs.bashmount}";
        };

        # The memory module displays the current RAM and swap utilization
        "memory" = {
          # The format, how information should be displayed
          format = "{used:0.1f}GiB  ";
        };

        # The cpu module displays the current cpu utilization
        "cpu" = {
          # The format, how information should be displayed
          format = "{usage}%  ";
        };

        # The battery module displays the current capacity and state (eg. charging) of your battery
        "battery" = {
          # The format, how information should be displayed
          format = "{capacity}% {icon}";

          # The format, how information should be displayed when charging
          format-charging = "{capacity}%  ";

          # The format, how information should be displayed when done charging
          format-plugged = "{capacity}%  ";

          # Based on the current value, the corresponding icon gets selected
          format-icons = [
            "  "
            "  "
            "  "
            "  "
            "  "
          ];
        };

        # The notifications module displays the number of notifications unread
        "custom/notifications" = {
          # The format, how information should be displayed
          format = "{} {icon}";

          # Based on the current value, the corresponding icon gets selected
          format-icons = {
            notification = " ";
            none = " ";
            dnd-notification = " ";
            dnd-none = " ";
            inhibited-notification = " ";
            inhibited-none = " ";
            dnd-inhibited-notification = " ";
            dnd-inhibited-none = " ";
          };

          # Expected output type of exec script
          return-type = "json";

          # The path to a script which executes and outputs
          exec = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";

          # Command to execute when clicked on the module
          on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";

          # Command to execute when you right clicked on the module
          on-click-right = "${pkgs.swaynotificationcenter}/bin/swaync-client -d -sw";

          # Option to enable escaping of script output
          escape = true;
        };
      }
    ];

    # CSS style of the bar
    style = ''
      * {
        font-weight: bold;
      }

      window#waybar > box {
        margin: 0 4px;
      }

      window#waybar.empty {
        background: transparent;
      }

      window .modules-left #workspaces button {
        background: transparent;
        color: @base03;
        padding: 0;
        margin: 6px 4px 6px 0;
        border-radius: 100%;
        min-width: 20px;
        min-height: 20px;
      }

      .modules-left #workspaces button.focused,
      .modules-left #workspaces button.active {
        background: transparent;
        color: @base07;
      }

      .modules-left #workspaces button.urgent {
        background: transparent;
        color: @base08;
      }

      .modules-left #window {
        background: transparent;
      }

      .modules-right #idle_inhibitor {
        background: transparent;
        color: @base07;
      }

      .modules-right #backlight {
        background: transparent;
        color: @base07;
      }

      .modules-right #wireplumber,
      .modules-right #pulseaudio,
      .modules-right #sndio {
        background: transparent;
        color: @base07;
      }

      .modules-right #wireplumber.muted,
      .modules-right #pulseaudio.muted,
      .modules-right #sndio.muted {
        background: transparent;
      }

      .modules-right #disk {
          background: transparent;
      lor: @base07;
      }

      .modules-right #memory {
          background: transparent;
          color: @base07;
      }

      .modules-right #cpu {
        background: transparent;
        color: @base07;
      }

      .modules-center #clock {
        background: transparent;
        color: @base07;
      }

      .modules-right #upower,
      .modules-right #battery {
        background: transparent;
        color: @base07;
      }

      .modules-right #upower.charging,
      .modules-right #battery.Charging {
        background: transparent;
      }
    '';

    systemd = {
      # Whether to enable Waybar systemd integration
      enable = true;

      # The systemd target that will automatically start the Waybar service
      target = "${config._module.args.desktop}-session.target";
    };
  };

  # Whether to enable theming for Waybar
  stylix.targets.waybar.enableLeftBackColors = true;
  stylix.targets.waybar.enableCenterBackColors = true;
  stylix.targets.waybar.enableRightBackColors = true;

  # The set of packages to appear in the user environment
  home.packages = with pkgs; [
    font-awesome
    nerdfonts
  ];

  wayland.windowManager.sway = mkIf (config.wayland.windowManager.sway.enable) {
    # Sway configuration options
    config = {
      # List of commands that should be executed on specific windows
      window.commands = [
        {
          # Swaywm command to execute
          command = "floating enable, move position center, resize set width 50 ppt height 50 ppt, sticky, fullscreen disable";

          # Criteria of the windows on which command should be executed
          criteria = {
            title = "ncpamixer";
          };
        }
        {
          # Swaywm command to execute
          command = "floating enable, move position center, resize set width 50 ppt height 50 ppt, sticky, fullscreen disable";

          # Criteria of the windows on which command should be executed
          criteria = {
            title = "bashmount";
          };
        }
      ];
    };
  };

  # Hyprland configuration written in Nix
  wayland.windowManager.hyprland = mkIf (config.wayland.windowManager.hyprland.enable) {
    settings = {
      windowrulev2 = [
        "float, title:^(ncpamixer)"
        "center, title:^(ncpamixer)"
        "size 50% 50%, title:^(ncpamixer)"
        "pin, title:^(ncpamixer)"
        "stayfocused, title:^(ncpamixer)"
        "suppressevent fullscreen maximize active activatefocus, title:^(ncpamixer)"
        "dimaround, title:^(ncpamixer)"

        "float, title:^(bashmount)"
        "center, title:^(bashmount)"
        "size 50% 50%, title:^(bashmount)"
        "pin, title:^(bashmount)"
        "stayfocused, title:^(bashmount)"
        "suppressevent fullscreen maximize active activatefocus, title:^(bashmount)"
        "dimaround, title:^(bashmount)"
      ];
    };
  };
}
