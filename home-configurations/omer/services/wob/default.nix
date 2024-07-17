{
  services.wob = {
    # Whether to enable wob
    enable = true;

    # Configuration written to $XDG_CONFIG_HOME/wob/wob.ini
    settings = {
      "" = {
        # Anchor point, combination of top, left, right, bottom, center
        anchor = "bottom";

        # Anchor  margin,  in pixels. Either as a single value or 4 values (top right bottom left)
        margin = "0 0 50 0";
      };
    };

    # Whether to enable systemd service and socket for wob
    systemd = true;
  };
}
