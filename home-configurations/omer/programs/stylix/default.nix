{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  stylix = mkIf (config.stylix.enable) {
    # A scheme following the base16 standard
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";

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
