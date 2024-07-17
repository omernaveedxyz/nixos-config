{ config, sops-nix, ... }:
{
  imports = [ sops-nix.nixosModules.sops ];

  sops = {
    # Specify using persistent SSH key path for sops-nix
    gnupg.sshKeyPaths =
      if (config._module.args.impermanence) then
        [ "/persistent/etc/ssh/ssh_host_rsa_key" ]
      else
        [ "/etc/ssh/ssh_host_rsa_key" ];

    # Specify using persistent SSH key path for sops-nix
    age.sshKeyPaths = [ ];
  };
}
