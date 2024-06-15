{ config, ... }:
{
  programs.direnv = {
    # Whether to enable direnv, the environment switcher
    enable = true;

    # Whether to enable Bash integration
    enableBashIntegration = true;

    # Whether to enable nix-direnv
    nix-direnv.enable = true;
  };

  # Files and directories to persistent across ephemeral boots
  home.persistence."/persistent/home/${config.home.username}" = {
    # All directories you want to link or bind to persistent storage
    directories = [ ".local/share/direnv" ];
  };
}
