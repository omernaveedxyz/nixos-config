{ config, pkgs, ... }:
{
  services.clipman = {
    # Whether to enable clipman, a simple clipboard manager for Wayland
    enable = true;

    # The systemd target that will automatically start the clipman service
    systemdTarget = "${config._module.args.desktop}-session.target";
  };

  # The set of packages to appear in the user environment
  home.packages = with pkgs; [ wl-clipboard ];
}
