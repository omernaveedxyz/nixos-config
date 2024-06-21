{ config, lib, ... }:
let
  inherit (lib) mkIf;
in
{
  # Files and directories to persistent across ephermal boots
  home.persistence."/persistent/home/${config.home.username}" =
    mkIf (config._module.args.impermanence)
      {
        # All directories you want to bind mount to persistent storage
        directories = [ ".local/state/wireplumber" ];
      };
}
