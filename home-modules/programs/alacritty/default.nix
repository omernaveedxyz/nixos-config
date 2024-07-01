{ config, lib, ... }:
let
  inherit (lib) mkIf getExe;
in
mkIf (config._module.args.terminal == "alacritty") {
  programs.alacritty = {
    # Whether to enable Alacritty
    enable = true;

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
  home.sessionVariables = {
    TERMINAL = "${getExe config.programs.alacritty.package}";
  };
}
