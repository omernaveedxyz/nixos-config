{
  config,
  lib,
  relativeToRoot,
  ...
}:
let
  inherit (lib) optionals;
in
{
  users = {
    # If set to true, you are free to add new users and groups to the system
    # with the ordinary useradd and groupadd commands. On system activation,
    # the existing contents of the /etc/passwd and /etc/group files will be
    # merged with the contents generated from the users.users and users.groups
    # options. The initial password for a user will be set according to the
    # users.users, but existing password will not be changed.
    #
    # If set to false, the contents of the user and group files will simply be
    # replaced on system activation. This also holds for the user passwords;
    # all changed passwords will reset according to the users.users
    # configuration on activation.
    mutableUsers = false;

    users = {
      omer = {
        # Indicates whether this is an account for a "real" user
        isNormalUser = true;

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
  system.activationScripts."create-persistent-home@omer".text = ''
      	if [ ! -d /persistent/home/omer ]; then
    		mkdir -p /persistent/home/omer
    		chmod 0700 /persistent/home/omer
    		chown -R 1000:100 /persistent/home/omer
    	fi
  '';

  # Specify encrypted sops secret to access
  sops.secrets."users/users/omer/hashedPasswordFile" = {
    sopsFile = relativeToRoot "nixos-modules/secrets.yaml";
    neededForUsers = true;
  };
}
