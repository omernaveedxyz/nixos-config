{ config, ... }:
{
  services.swayidle = {
    # Whether to enable idle manager for Wayland
    enable = config.wayland.windowManager.sway.enable;
  };
}
