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
    base16Scheme = "${pkgs.base16-schemes}/share/themes/helios.yaml";

    # Wallpaper image
    image = ./wallpaper.png;

    cursor = {
      # Package providing the cursor theme
      package = pkgs.bibata-cursors;

      # The cursor name within the package
      name = "Bibata-Modern-Amber";

      # The cursor size
      size = 24;
    };
  };
}
