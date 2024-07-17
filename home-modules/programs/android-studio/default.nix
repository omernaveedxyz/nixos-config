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
  home.packages = with pkgs; [ android-studio ];

  # Allow installing specific unfree packages
  allowedUnfree = [ "android-studio-stable" ];

  # Files and directories to persistent across ephemeral boots
  home.persistence."/persistent/home/${config.home.username}" =
    mkIf (config._module.args.impermanence)
      {
        # All directories you want to link or bind to persistent storage
        directories = config._module.args.relativeToHome [
          "${config.xdg.configHome}/.android"
          "${config.xdg.configHome}/Google"
        ];

        # All files you want to link or bind to persistent storage
        files = config._module.args.relativeToHome [
          "${config.xdg.dataHome}/Google/consentOptions/accepted"
        ];
      };
}
