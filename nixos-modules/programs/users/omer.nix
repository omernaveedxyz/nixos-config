{
  config,
  lib,
  relativeToRoot,
  ...
}:
let
  inherit (lib) optionals mkIf;
in
{
  users = {
    users = {
      omer = {
        # Indicates whether this is an account for a "real" user
        isNormalUser = true;

        # The account UID
        uid = 1000;

        # The full path to a file that contains the hash of the user's passwod
        hashedPasswordFile = config.sops.secrets."users/users/omer/hashedPasswordFile".path;

        # The user's auxiliary groups
        extraGroups =
          [ "wheel" ]
          ++ optionals config.networking.networkmanager.enable [ "networkmanager" ]
          ++ optionals config.virtualisation.libvirtd.enable [ "libvirtd" ];

        # A list of files each containing one OpenSSH public key that should be
        # added to the user's authorized keys
        openssh.authorizedKeys.keyFiles = [ (relativeToRoot "home-configurations/omer/id_rsa.pub") ];
      };
    };
  };

  # A set of shell script fragments that are executed when a NixOS system configuration is activated
  system.activationScripts = mkIf (config._module.args.impermanence) {
    "create-persistent-home@omer".text = ''
      if [ ! -d /persistent/home/omer ]; then
        mkdir -p /persistent/home/omer
        chmod 0700 /persistent/home/omer
        chown -R 1000:100 /persistent/home/omer
      fi
    '';
  };

  # Specify encrypted sops secret to access
  sops.secrets."users/users/omer/hashedPasswordFile" = {
    sopsFile = relativeToRoot "nixos-modules/secrets.yaml";
    neededForUsers = true;
  };
}
