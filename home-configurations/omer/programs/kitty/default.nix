{ config, lib, ... }:
let
  inherit (lib) mkIf getExe;
in
mkIf (config._module.args.terminal == "kitty") {
  programs.kitty = {
    # Whether to enable Kitty terminal emulator
    enable = true;

    # Configuration written to $XDG_CONFIG_HOME/kitty/kitty.conf
    settings = {
      # The window padding (in pts) (blank area between the text and the window border)
      window_padding_width = 4;
    };
  };

  # Environment variables to always set at login
  home.sessionVariables = {
    TERMINAL = "${getExe config.programs.kitty.package}";
  };
}
