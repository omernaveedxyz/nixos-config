{ lanzaboote, ... }:
{
  imports = [ lanzaboote.nixosModules.lanzaboote ];

  boot.lanzaboote = {
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
  environment.persistence."/persistent" = {
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
