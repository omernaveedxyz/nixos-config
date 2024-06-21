{ config, lib, ... }:
let
  inherit (lib) mkIf getExe;
in
{
  programs.kitty = {
    # Whether to enable Kitty terminal emulator
    enable = config._module.args.terminal == "kitty";
  };

  # Environment variables to always set at login
  home.sessionVariables = mkIf (config.programs.kitty.enable) {
    TERMINAL = "${getExe config.programs.kitty.package}";
  };
}
