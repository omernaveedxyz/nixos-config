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
  home.packages = with pkgs; [
    protonmail-desktop
    proton-pass
  ];

  # Files and directories to persistent across ephemeral boots
  home.persistence."/persistent/home/${config.home.username}" =
    mkIf (config._module.args.impermanence)
      {
        # All directories you want to link or bind to persistent storage
        directories = [
          ".config/Proton Mail"
          ".config/Proton Pass"
        ];
      };
}
