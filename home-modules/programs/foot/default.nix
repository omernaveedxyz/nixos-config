{ config, lib, ... }:
let
  inherit (lib) mkIf getExe;
in
{
  programs.foot = {
    # Whether to enable Foot terminal
    enable = config._module.args.terminal == "foot";

    # Whether to enable Foot terminal server
    server.enable = true;
  };

  # Environment variables to always set at login
  home.sessionVariables = mkIf (config.programs.foot.enable) {
    TERMINAL = "${getExe config.programs.alacritty.package}";
  };
}
