{
  lib,
  pkgs,
  relativeToRoot,
  ...
}:
let
  inherit (builtins) readDir;
  inherit (lib) getExe attrNames;
in
{
  users.users.colmena = {
    # Indicates if the user is a system user or not
    isSystemUser = true;

    # The user's primary group
    group = "colmena";

    # The path to the user's shell
    shell = getExe pkgs.bash;

    # A list of files each containing one OpenSSH public key that should be added
    # to the user's authorized keys
    openssh.authorizedKeys.keyFiles = map (
      name: relativeToRoot "home-configurations/${name}/id_rsa.pub"
    ) (attrNames (readDir (relativeToRoot "home-configurations")));
  };

  # Additional group to be created
  users.groups.colmena = { };

  # Define specific rules to be in the sudoers file
  # HACK: https://github.com/zhaofengli/colmena/issues/165
  security.sudo.extraRules = [
    {
      users = [ "colmena" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
