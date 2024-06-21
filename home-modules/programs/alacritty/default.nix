{ config, lib, ... }:
let
  inherit (lib) mkIf getExe;
in
{
  programs.alacritty = {
    # Whether to enable Alacritty
    enable = config._module.args.terminal == "alacritty";
  };

  # Environment variables to always set at login
  home.sessionVariables = mkIf (config.programs.alacritty.enable) {
    TERMINAL = "${getExe config.programs.alacritty.package}";
  };
}
