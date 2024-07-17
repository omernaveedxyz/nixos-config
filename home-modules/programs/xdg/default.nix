{ config, lib, ... }:
let
  inherit (lib) mkIf;
in
{
  xdg = {
    # Whether to enable management of XDG base directories
    enable = true;

    userDirs = {
      # Whether to manage $XDG_CONFIG_HOME/user-dirs.dirs
      enable = true;

      # Whether to enable automatic creation of the XDG user directories
      createDirectories = true;
    };
  };

  # Files and directories to persistent across ephemeral boots
  home.persistence."/persistent/home/${config.home.username}" =
    mkIf (config._module.args.impermanence)
      {
        # All directories you want to link or bind to persistent storage
        directories = config._module.args.relativeToHome (
          with config.xdg.userDirs;
          [
            desktop
            documents
            download
            music
            pictures
            publicShare
            templates
            videos
          ]
        );
      };
}
