{
  config,
  lib,
  pkgs,
  impermanence,
  sops-nix,
  microvm,
  relativeToRoot,
  ...
}:
let
  inherit (builtins) readFile;
  inherit (lib)
    listToAttrs
    attrNames
    mkIf
    concatMap
    ;

  # Function to generate attribute set of microvm configurations given vm names
  mkMicrovms =
    microvms:
    listToAttrs (
      map (hostname: {
        name = hostname;
        value = {
          # The package set to use for the microvm
          inherit pkgs;

          # A set of special arguments to be passed to the MicroVM's NixOS modules
          specialArgs = {
            inherit
              impermanence
              sops-nix
              microvm
              hostname
              relativeToRoot
              ;
          };

          # The configuration for the MicroVM
          config = {
            imports = [ (relativeToRoot "microvm-configurations/${hostname}") ];
          };
        };
      }) microvms
    );
in
{
  imports = [ microvm.nixosModules.host ];

  # Define MicroVMs to run on the system
  microvm.vms = mkMicrovms [ "vm-xmrig" ];

  # Rules for creation, deletion and cleaning of volatile and temporary files automatically
  systemd.tmpfiles.rules = map (
    vm:
    let
      id = readFile (relativeToRoot "microvm-configurations/${vm}/machine-id");
      guest = "/var/lib/microvms/${vm}/persistent/var/log/journal/${id}";
      host = "/var/log/journal/${vm}";
    in
    "L+ ${host} - - - - ${guest}"
  ) (attrNames config.microvm.vms);

  # Modules to help you handle persistent state on systems with ephemeral root storage
  environment.persistence."/persistent" = mkIf (config._module.args.impermanence) {
    # All directories you want to link or bind to persistent storage
    directories = [
      {
        directory = "/var/lib/microvms";
        user = "root";
        group = "root";
        mode = "0755";
      }
    ];
  };

  # Specify encrypted sops secret to access
  sops.secrets = listToAttrs (
    concatMap (
      microvm:
      concatMap
        (file: [
          {
            name = "${microvm}/${file}";
            value = {
              sopsFile = (relativeToRoot "microvm-configurations/${microvm}/secrets.yaml");
              mode = "0600";
            };
          }
          {
            name = "${microvm}/${file}.pub";
            value = {
              sopsFile = (relativeToRoot "microvm-configurations/${microvm}/secrets.yaml");
              mode = "0644";
            };
          }
        ])
        [
          "ssh_host_ed25519_key"
          "ssh_host_rsa_key"
        ]
    ) (attrNames config.microvm.vms)
  );

  # The file systems to be mounted
  fileSystems = listToAttrs (
    map (microvm: {
      name = "/var/lib/microvms/${microvm}/persistent/etc/ssh";
      value = {
        device = "/run/secrets/${microvm}";
        options = [ "bind" ];
      };
    }) (attrNames config.microvm.vms)
  );
}
