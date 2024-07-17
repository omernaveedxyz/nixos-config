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
    stringAfter
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
  microvm.vms = mkMicrovms [
    "vm-xmrig"
    "vm-miniflux"
    "vm-jellyfin"
  ];

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
    directories = map (microvm: {
      directory = "/var/lib/microvms/${microvm}/persistent";
      user = "root";
      group = "root";
      mode = "0755";
    }) (attrNames config.microvm.vms);
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
        depends = [ "/var/lib/microvms/${microvm}/persistent" ];
        fsType = "none";
        options = [
          "bind"
          "ro"
        ];
      };
    }) (attrNames config.microvm.vms)
  );

  # A set of shell script fragments that are executed when a NixOS system configuration is activated
  system.activationScripts = listToAttrs (
    map (microvm: {
      name = "remount_${microvm}_ssh_bind_mount";
      value = stringAfter [ "setupSecrets" ] ''
        if ${pkgs.systemd}/bin/systemctl is-active --quiet microvm@${microvm}.service && ${pkgs.util-linux}/bin/mountpoint --quiet /var/lib/microvms/${microvm}/persistent/etc/ssh; then
          ${pkgs.systemd}/bin/systemctl stop --quiet microvm@${microvm}.service || true
          umount /var/lib/microvms/${microvm}/persistent/etc/ssh
          mount -o bind,ro /run/secrets/${microvm} /var/lib/microvms/${microvm}/persistent/etc/ssh
          ${pkgs.systemd}/bin/systemctl start --quiet microvm@${microvm}.service || true
        elif ${pkgs.util-linux}/bin/mountpoint --quiet /var/lib/microvms/${microvm}/persistent/etc/ssh; then
          umount /var/lib/microvms/${microvm}/persistent/etc/ssh
          mount -o bind,ro /run/secrets/${microvm} /var/lib/microvms/${microvm}/persistent/etc/ssh
        fi
      '';
    }) (attrNames config.microvm.vms)
  );

  # Allow specific unfree packages
  allowedUnfree = [ "unrar" ];
}
