{ config, stylix, ... }:
{
  imports = [ stylix.homeManagerModules.stylix ];

  stylix = {
    # Whether to enable stylix
    enable = true;

    # Wallpaper image
    image = ../../home-configurations/${config.home.username}/wallpaper.png;

    # Use this option to force a light or dark theme
    polarity = "dark";
  };
}
