{ config, ... }:
{
  # Files and directories to persistent across ephermal boots
  home.persistence."/persistent/home/${config.home.username}" = {
    # All directories you want to bind mount to persistent storage
    directories = [ ".local/state/wireplumber" ];
  };
}
