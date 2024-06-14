{ config, ... }:
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
        extraGroups = [
          "wheel"
          "networkmanager"
          "libvirtd"
        ];
      };
    };
  };

  # Specify encrypted sops secret to access
  sops.secrets."users/users/omer/hashedPasswordFile" = {
    sopsFile = ../secrets.yaml;
    neededForUsers = true;
  };
}
