{
  programs.waybar = {
    # Whether to enable Waybar
    enable = true;

    # Configuration for Waybar
    settings = [
      {
        layer = "bottom";
        position = "top";
        height = 30;

        modules-left = [ "sway/workspaces" ];
        modules-center = [ ];
        modules-right = [
          "wireplumber"
          "backlight"
          "network"
          "disk"
          "memory"
          "cpu"
          "battery"
          "clock"
        ];

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };
      }
    ];

    # CSS style of the bar
    style = '''';

    # Whether to enable Waybar systemd integration
    systemd.enable = true;

    # The systemd target that will automatically start the Waybar service
    systemd.target = "sway-session.target";
  };
}
