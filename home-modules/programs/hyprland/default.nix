{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe;
in
{
  wayland.windowManager.hyprland = {
    # Whether to enable Hyprland wayland compositor
    enable = config._module.args.desktop == "hyprland";

    # Hyprland configuration written in Nix
    settings = {
      exec = [ "${getExe pkgs.waybar}" ];

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

        # Extends the area around the border where you can click and drag on
        extend_border_grab_area = 15;

        # Show a cursor icon when hovering over borders, only used when general:resize_on_border is on
        hover_icon_on_border = true;
      };

      decoration = {
        # Rounded corners’ radius
        rounding = 0;

        # Opacity of active windows
        active_opacity = 1.0;

        # Opacity of inactive windows
        inactive_opacity = 1.0;

        # Opacity of fullscreen windows
        fullscreen_opacity = 1.0;

        # Enable drop shadows on windows
        drop_shadow = true;

        # Shadow range
        shadow_range = 4;

        # In what power to render the falloff
        shadow_render_power = 3;

        # If true, the shadow will not be rendered behind the window itself, only around it
        shadow_ignore_window = true;

        # Shadow’s scale
        shadow_scale = 1.0;

        # Enables dimming of inactive windows
        dim_inactive = false;

        # How much inactive windows should be dimmed
        dim_strength = 0.5;

        # How much to dim the rest of the screen by when a special workspace is open
        dim_special = 0.2;

        # How much the `dimaround` window rule should dim by
        dim_around = 0.4;
      };

      decoration.blur = {
        # Enable kawase window background blur
        enabled = false;

        # Blur size (distance)
        size = 8;

        # The amount of passes to perform
        passes = 1;

        # Make the blur layer ignore the opacity of the window
        ignore_opacity = false;

        # If enabled, floating windows will ignore tiled windows in their blur
        xray = false;

        # How much noise to apply
        noise = 1.17e-2;

        # Contrast modulation for blur
        contrast = 0.8916;

        # Brightness modulation for blur
        brightness = 0.8172;

        # Increase saturation of blurred colors
        vibrancy = 0.1696;

        # How strong the effect of vibrancy is on dark areas
        vibrancy_darkness = 0.0;

        # Whether to blur behind the special workspace
        special = false;

        # Whether to blur popups
        popups = false;
      };

      animations = {
        # Enable animations
        enabled = false;

        # Enable first launch animation
        first_launch_animation = false;
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

        # Whether a newly open window should replace the master or join the slaves
        new_is_master = false;

        # Whether a newly open window should be on the top of the stack
        new_on_top = false;

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
        "$Mod, d, exec, ${pkgs.dmenu}/bin/dmenu_path |${pkgs.dmenu}/bin/dmenu"
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
        ", XF86MonBrightnessDown, exec, ${getExe pkgs.brightnessctl} set 5%-"
        ", XF86MonBrightnessUp, exec, ${getExe pkgs.brightnessctl} set 5%+"
        "Shift, XF86MonBrightnessDown, exec, ${getExe pkgs.brightnessctl} set 1%-"
        "Shift, XF86MonBrightnessUp, exec, ${getExe pkgs.brightnessctl} set 1%+"
        "$Mod Shift, XF86MonBrightnessDown, exec, ${getExe pkgs.brightnessctl} set 0%"
        "$Mod Shift, XF86MonBrightnessUp, exec, ${getExe pkgs.brightnessctl} set 100%"

        # Audio
        ", XF86AudioLowerVolume, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%"
        ", XF86AudioRaiseVolume, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%"
        "Shift, XF86AudioLowerVolume, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -1%"
        "Shift, XF86AudioRaiseVolume, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +1%"
        "$Mod Shift, XF86AudioLowerVolume, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ 0%"
        "$Mod Shift, XF86AudioRaiseVolume, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ 100%"
        ", XF86AudioMute, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle"
      ];

      bindm = [
        # Move/resize windows
        "$Mod, mouse:272, movewindow"
        "$Mod, mouse:273, resizewindow"
      ];

      bindl = [
        # Enable/Disable inner-display on lid switch
        ", switch:on:Lid Switch, exec, hyprctl keyword monitor 'eDP-1, disable'"
        ", switch:off:Lid Switch, exec, hyprctl keyword monitor 'eDP-1, preferred, auto, 1'"
      ];

      windowrulev2 = [
        "float, title:^(ncpamixer)"
        "center, title:^(ncpamixer)"
      ];
    };
  };
}
