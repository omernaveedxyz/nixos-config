{
  services.wob = {
    # Whether to enable wob
    enable = true;

    # Configuration written to $XDG_CONFIG_HOME/wob/wob.ini
    settings = { };

    # Whether to enable systemd service and socket for wob
    systemd = true;
  };
}
