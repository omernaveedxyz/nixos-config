{ pkgs, ... }:
{
  services.swayidle = {
    # Whether to enable idle manager for Wayland
    enable = true;

    # Run command on occurrence of a event
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock -fF";
      }
    ];
  };
}
