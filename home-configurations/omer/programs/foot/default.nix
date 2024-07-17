{ config, lib, ... }:
let
  inherit (lib) mkIf getExe;
in
mkIf (config._module.args.terminal == "foot") {
  programs.foot = {
    # Whether to enable Foot terminal
    enable = true;

    # Whether to enable Foot terminal server
    server.enable = true;

    # Configuration written to $XDG_CONFIG_HOME/foot/foot.ini
    settings = {
      main = {
        # Padding between border and glyphs, in pixels (subject to output scaling), in the form XxY
        pad = "4x4";
      };
    };
  };

  # Environment variables to always set at login
  home.sessionVariables = {
    TERMINAL = "${getExe config.programs.foot.package}";
  };
}
