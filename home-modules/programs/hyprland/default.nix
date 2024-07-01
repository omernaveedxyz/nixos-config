{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf getExe;
in
mkIf (config._module.args.desktop == "hyprland") {
  wayland.windowManager.hyprland = {
    # Whether to enable Hyprland wayland compositor
    enable = true;

    # Hyprland configuration written in Nix
    settings = {
      general = {
        # Size of the border around windows
        border_size = 2;

        # Disable borders for floating windows
        no_border_on_floating = false;

        # Gaps between windows
        gaps_in = 4;

        # Gaps between windows and monitor edges
        gaps_out = 8;

        # Gaps between workspaces
        gaps_workspaces = 0;

        # Which layout to use
        layout = "master";

        # If true, will not fall back to the next available window when moving focus in a direction where no window was found
        no_focus_fallback = true;

        # Enables resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true;

        # Show a cursor icon when hovering over borders, only used when general:resize_on_border is on
        hover_icon_on_border = true;
      };

      decoration = {
        # Rounded corners’ radius
        rounding = 4;

        # Opacity of active windows
        active_opacity = 0.9;

        # Opacity of inactive windows
        inactive_opacity = 0.9;

        # Opacity of fullscreen windows
        fullscreen_opacity = 0.9;

        # Enables dimming of inactive windows
        dim_inactive = true;
      };

      decoration.blur = {
        # Enable kawase window background blur
        enabled = true;
      };

      animations = {
        # Enable animations
        enabled = true;

        # Enable first launch animation
        first_launch_animation = true;
      };

      input = {
        # The repeat rate for held-down keys, in repeats per second
        repeat_rate = 50;

        # Delay before a held-down key is repeated, in milliseconds
        repeat_delay = 300;

        # Specify if and how cursor movement should affect window focus
        ## 0 - Cursor movement will not change focus.
        ## 1 - Cursor movement will always change focus to the window under the cursor.
        ## 2 - Cursor focus will be detached from keyboard focus. Clicking on a window will move keyboard focus to that window.
        ## 3 - Cursor focus will be completely separate from keyboard focus. Clicking on a window will not change keyboard focus.
        follow_mouse = 1;

        touchpad = {
          # Disable the touchpad while typing
          disable_while_typing = false;

          # Inverts scrolling direction
          natural_scroll = true;
        };
      };

      gestures = {
        # Enable workspace swipe gesture
        workspace_swipe = true;
      };

      misc = {
        # Disables the random hyprland logo
        disable_hyprland_logo = true;

        # If true, will animate manual window resizes/moves
        animate_manual_resizes = true;

        # If true, will animate windows being dragged by mouse
        animate_mouse_windowdragging = true;

        # If there is a fullscreen window, whether a new tiled window opened should replace the fullscreen one or stay behind
        ## 0 - behind
        ## 1 - takes over
        ## 2 - unfullscreen the current fullscreen window
        new_window_takes_over_fullscreen = 2;

        # Enable window swallowing
        enable_swallow = true;

        # The class regex to be used for windows that should be swallowed
        swallow_regex = "^(${config._module.args.terminal})$";
      };

      # The general config of a monitor
      ## monitor=name,resolution,position,scale
      monitor = ",preferred,auto,1";

      # Animations are declared with the animation keyword
      ## animation=NAME,ONOFF,SPEED,CURVE[,STYLE]
      animation = "global,1,3,default";

      master = {
        # Master split factor, the ratio of master split
        mfact = 0.5;

        # Whether to apply gaps when there is only one window on a workspace
        ## 0 - disabled 
        ## 1 - no border
        ## 2 - with border
        no_gaps_when_only = 0;
      };

      "$Mod" = "ALT";

      bind = [
        # General
        "$Mod, return, exec, ${config.home.sessionVariables.TERMINAL}"
        "$Mod Shift, q, killactive, "
        "$Mod Shift, c, exit, "

        # Focus
        "$Mod, h, movefocus, l"
        "$Mod, l, movefocus, r"
        "$Mod, j, movefocus, d"
        "$Mod, k, movefocus, u"

        # Move
        "$Mod Shift, h, movewindow, l"
        "$Mod Shift, l, movewindow, r"
        "$Mod Shift, j, movewindow, d"
        "$Mod Shift, k, movewindow, u"

        # Layout
        "$Mod Shift, return, layoutmsg, swapwithmaster"
        "$Mod, backspace, layoutmsg, mfact exact 0.5"
        "$Mod, f, fullscreen, "

        # Floating
        "$Mod Shift, Space, togglefloating, "

        # Workspaces
        "$Mod, 1, workspace, 1"
        "$Mod, 2, workspace, 2"
        "$Mod, 3, workspace, 3"
        "$Mod, 4, workspace, 4"
        "$Mod, 5, workspace, 5"
        "$Mod, 6, workspace, 6"
        "$Mod, 7, workspace, 7"
        "$Mod, 8, workspace, 8"
        "$Mod, 9, workspace, 9"
        "$Mod, 0, workspace, 10"

        # Move active window to workspace
        "$Mod Shift, 1, movetoworkspacesilent, 1"
        "$Mod Shift, 2, movetoworkspacesilent, 2"
        "$Mod Shift, 3, movetoworkspacesilent, 3"
        "$Mod Shift, 4, movetoworkspacesilent, 4"
        "$Mod Shift, 5, movetoworkspacesilent, 5"
        "$Mod Shift, 6, movetoworkspacesilent, 6"
        "$Mod Shift, 7, movetoworkspacesilent, 7"
        "$Mod Shift, 8, movetoworkspacesilent, 8"
        "$Mod Shift, 9, movetoworkspacesilent, 9"
        "$Mod Shift, 0, movetoworkspacesilent, 10"

        # VPN
        "$Mod Shift, v, exec, ${pkgs.libnotify}/bin/notify-send 'Starting VPN' && sudo ${pkgs.systemd}/bin/systemctl start wg-quick-wg0.service"
        "$Mod, v, exec, ${pkgs.libnotify}/bin/notify-send 'Stopping VPN' && sudo ${pkgs.systemd}/bin/systemctl stop wg-quick-wg0.service"

        # Brightness
        ", XF86MonBrightnessDown, exec, ${getExe pkgs.brightnessctl} set 5%- | sed -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > /run/user/1000/wob.sock"
        ", XF86MonBrightnessUp, exec, ${getExe pkgs.brightnessctl} set 5%+ | sed -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > /run/user/1000/wob.sock"
        "Shift, XF86MonBrightnessDown, exec, ${getExe pkgs.brightnessctl} set 1%- | sed -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > /run/user/1000/wob.sock"
        "Shift, XF86MonBrightnessUp, exec, ${getExe pkgs.brightnessctl} set 1%+ | sed -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > /run/user/1000/wob.sock"
        "$Mod Shift, XF86MonBrightnessDown, exec, ${getExe pkgs.brightnessctl} set 0% | sed -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > /run/user/1000/wob.sock"
        "$Mod Shift, XF86MonBrightnessUp, exec, ${getExe pkgs.brightnessctl} set 100% | sed -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > /run/user/1000/wob.sock"

        # Audio
        ", XF86AudioLowerVolume, exec, ${getExe pkgs.pamixer} --decrease 5 && ${getExe pkgs.pamixer} --get-volume > /run/user/1000/wob.sock"
        ", XF86AudioRaiseVolume, exec, ${getExe pkgs.pamixer} --increase 5 && ${getExe pkgs.pamixer} --get-volume > /run/user/1000/wob.sock"
        "Shift, XF86AudioLowerVolume, exec, ${getExe pkgs.pamixer} --decrease 1 && ${getExe pkgs.pamixer} --get-volume > /run/user/1000/wob.sock"
        "Shift, XF86AudioRaiseVolume, exec, ${getExe pkgs.pamixer} --increase 1 && ${getExe pkgs.pamixer} --get-volume > /run/user/1000/wob.sock"
        "$Mod Shift, XF86AudioLowerVolume, exec, ${getExe pkgs.pamixer} --set-volume 0 && ${getExe pkgs.pamixer} --get-volume > /run/user/1000/wob.sock"
        "$Mod Shift, XF86AudioRaiseVolume, exec, ${getExe pkgs.pamixer} --set-volume 100 && ${getExe pkgs.pamixer} --get-volume > /run/user/1000/wob.sock"
        ", XF86AudioMute, exec, ${getExe pkgs.pamixer} --toggle-mute && ( [ \"$(${getExe pkgs.pamixer} --get-mute)\" = \"true\" ] && echo 0 > /run/user/1000/wob.sock ) || ${getExe pkgs.pamixer} --get-volume > /run/user/1000/wob.sock"

	# Browser
        "$Mod Shift, b, exec, ${config.home.sessionVariables.BROWSER}"
        "Ctrl $Mod Shift, b, exec, ${config.home.sessionVariables.PRIVATE_BROWSER}"
      ];

      bindm = [
        # Move/resize windows
        "$Mod, mouse:272, movewindow"
        "$Mod, mouse:273, resizewindow"
      ];
    };
  };
}
