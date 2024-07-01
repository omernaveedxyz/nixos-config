{ config, lib, ... }:
let
  inherit (lib) mkIf getExe;
in
{
  programs.alacritty = {
    # Whether to enable Alacritty
    enable = config._module.args.terminal == "alacritty";

    # Configuration written to $XDG_CONFIG_HOME/alacritty/alacritty.toml
    settings = {
      # This section documents the [window] table of the configuration file
      window = {
        # Blank space added around the window in pixels
	padding = {
	  x = 4;
	  y = 4;
	};
      };
    };
  };

  # Environment variables to always set at login
  home.sessionVariables = mkIf (config.programs.alacritty.enable) {
    TERMINAL = "${getExe config.programs.alacritty.package}";
  };
}
