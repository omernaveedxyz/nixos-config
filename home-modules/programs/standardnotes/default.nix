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
  # The set of packages to appear in the user environment
  home.packages = [ pkgs.standardnotes ];

  # HACK: https://github.com/standardnotes/forum/issues/3626
  # Allow specific insecure packages
  nixpkgs.config.permittedInsecurePackages = [ "electron-27.3.11" ];

  # Files and directories to persistent across ephemeral boots
  home.persistence."/persistent/home/${config.home.username}" =
    mkIf (config._module.args.impermanence)
      {
        # All directories you want to link or bind to persistent storage
        directories = [ ".config/Standard Notes" ];
      };
}
