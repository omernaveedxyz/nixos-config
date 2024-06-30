{ config, lib, ... }:
let
  inherit (lib) mkIf;
in
{
  imports = [
    ./omer-media.nix
    ./omer-vault.nix
    ./omer-archive.nix
  ];

  # Modules to help you handle persistent state on systems with ephemeral root storage
  environment.persistence."/persistent" = mkIf (config._module.args.impermanence) {
    # All files you want to link or bind to persistent storage
    files = [
      {
        file = "/etc/keyfile";
        parentDirectory = {
          user = "root";
          group = "root";
          mode = "0755";
        };
      }
    ];
  };
}
