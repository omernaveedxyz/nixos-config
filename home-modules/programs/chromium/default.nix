{ config, lib, ... }:
let
  inherit (lib) mkIf getExe;
in
mkIf (config._module.args.browser == "chromium") {
  programs.chromium = {
    # Whether to enable Chromium
    enable = true;

    # List of Chromium extensions to install
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
    ];
  };

  # Environment variables to always set at login
  home.sessionVariables = {
    BROWSER = "${getExe config.programs.chromium.package}";
    PRIVATE_BROWSER = "${getExe config.programs.chromium.package} --incognito";
  };
}
