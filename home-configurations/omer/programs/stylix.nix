{ pkgs, stylix, ... }:
{
  imports = [ stylix.homeManagerModules.stylix ];

  stylix = {
    # Whether to enable stylix
    enable = true;

    # A scheme following the base16 standard
    base16Scheme = "${pkgs.base16-schemes}/share/themes/helios.yaml";

    # Wallpaper image
    image = ../wallpaper.png;

    cursor = {
      # Package providing the cursor theme
      package = pkgs.bibata-cursors;

      # The cursor name within the package
      name = "Bibata-Modern-Ice";

      # The cursor size
      size = 24;
    };
  };
}
