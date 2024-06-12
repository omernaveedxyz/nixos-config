{ lib, pkgs, ... }:
let
  inherit (lib) getExe;
in
{
  users.users.colmena = {
    # Indicates if the user is a system user or not
    isSystemUser = true;

    # The user's primary group
    group = "colmena";

    # The path to the user's shell
    shell = getExe pkgs.bash;
  };

  # Additional group to be created
  users.groups.colmena = { };

  # Define specific rules to be in the sudoers file
  # TODO: https://github.com/zhaofengli/colmena/issues/165
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
