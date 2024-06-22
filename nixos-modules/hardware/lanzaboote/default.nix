{
  config,
  lib,
  lanzaboote,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  imports = [ lanzaboote.nixosModules.lanzaboote ];

  boot.lanzaboote = mkIf (config._module.args.secureboot) {
    # Whether to enable Lanzaboote
    enable = true;

    # PKI bundle containing db, PK, KEK
    pkiBundle = "/etc/secureboot";

    # Maximum number of latest generations in the boot menu
    configurationLimit = 16;

    settings = {
      # Whether to allow editing the kernel command-line before boot
      editor = false;
    };
  };

  # Files and directories to persistent across ephemeral boots
  environment.persistence."/persistent" =
    mkIf (config._module.args.impermanence && config._module.args.secureboot)
      {
        # All directories you want to link or bind to persistent storage
        directories = [
          {
            directory = "/etc/secureboot";
            user = "root";
            group = "root";
            mode = "0755";
          }
        ];
      };
}
