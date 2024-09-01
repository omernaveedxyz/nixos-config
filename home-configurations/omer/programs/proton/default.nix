{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) hiPrio mkIf;
in
{
  # The set of packages to appear in the user environment
  home.packages = with pkgs; [
    # HACK: https://github.com/nix-community/home-manager/issues/5599
    (hiPrio protonmail-desktop)
    proton-pass
  ];

  # Files and directories to persistent across ephemeral boots
  home.persistence."/persistent/home/${config.home.username}" =
    mkIf (config._module.args.impermanence)
      {
        # All directories you want to link or bind to persistent storage
        directories = config._module.args.relativeToHome [
          "${config.xdg.configHome}/Proton Mail"
          "${config.xdg.configHome}/Proton Pass"
        ];
      };
}
