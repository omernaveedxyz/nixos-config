{ pkgs, stylix, ... }:
{
  imports = [ stylix.homeManagerModules.stylix ];

  stylix = {
    # Whether to enable stylix
    enable = true;

    # Wallpaper image
    image = ./wallpaper.png;

    # Base16 color scheme
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";

    cursor = {
      # Package providing the cursor theme
      package = pkgs.bibata-cursors;

      # The cursor name within the package
      name = "Bibata-Modern-Classic";

      # The cursor size
      size = 24;
    };

    opacity = {
      # The opacity of the windows of terminals
      terminal = 0.9;
    };
  };
}
