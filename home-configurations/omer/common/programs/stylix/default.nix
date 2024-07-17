{ pkgs, stylix, ... }:
{
  imports = [ stylix.homeManagerModules.stylix ];

  stylix = {
    # Whether to enable stylix
    enable = true;

    # Use this option to force a light or dark theme
    polarity = "dark";

    # Wallpaper image
    image = ./wallpaper.png;

    cursor = {
      # Package providing the cursor theme
      package = pkgs.bibata-cursors;

      # The cursor name within the package
      name = "Bibata-Modern-Classic";

      # The cursor size
      size = 24;
    };
  };
}
