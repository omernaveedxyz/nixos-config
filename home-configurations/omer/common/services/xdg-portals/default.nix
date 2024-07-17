{ pkgs, ... }:
{
  xdg.portal = {
    # Whether to enable XDG desktop integration
    enable = true;

    # List of additional portals that should be passed to the
    # xdg-desktop-portal.service, via the XDG_DESKTOP_PORTAL_DIR variable
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];

    # List of packages that provide XDG desktop portal configuration, usually
    # in the form of share/xdg-desktop-portal/$desktop-portals.conf
    configPackages = [ pkgs.sway ];
  };
}
