{ config, ... }:
{
  services.hypridle = {
    # Whether to enable Hypridle, Hyprland’s idle daemon
    enable = config._module.args.desktop == "hyprland";
  };
}
