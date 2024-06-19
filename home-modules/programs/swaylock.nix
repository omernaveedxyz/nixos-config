{ pkgs, ... }:
{
  programs.swaylock = {
    # Whether to enable swaylock
    enable = true;

    # The swaylock package to use
    package = pkgs.swaylock-effects;

    # Default arguments to swaylock
    settings = {
      # Sets the indicator to show even if idle
      indicator-idle-visible = true;

      # Sets the indicator radius
      indicator-radius = 120;

      # Show a clock in the indicator
      clock = true;
    };
  };
}
