{
  services.greetd = {
    # Whether to enable greetd
    enable = true;

    # Greetd configuration
    settings = rec {
      default_session = initial_session;
      initial_session = {
        user = "omer";
        command = "Hyprland";
      };
    };
  };
}
