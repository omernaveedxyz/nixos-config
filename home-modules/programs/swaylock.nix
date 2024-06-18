{ lib, ... }:
{
  programs.swaylock = {
    # Whether to enable swaylock
    enable = true;

    # Default arguments to swaylock
    settings = {
      # Sets the indicator to show even if idle
      indicator-idle-visible = true;

      # Sets the indicator radius
      indicator-radius = 120;

      # Sets the color of the inside of the indicator
      inside-color = lib.mkForce "00000000";
    };
  };
}
