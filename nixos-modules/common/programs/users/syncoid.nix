{
  config,
  lib,
  pkgs,
  relativeToRoot,
  ...
}:
let
  inherit (lib) mkIf getExe;
in
{
  # Additional user accounts to be created automatically by the system.
  users.users.syncoid = mkIf (config._module.args.impermanence) {
    # The user’s primary group
    group = "syncoid";

    # Indicates if the user is a system user or not
    isSystemUser = true;

    # The user’s home directory
    home = "/var/lib/syncoid";

    # Whether to create the home directory and ensure ownership as well as permissions to match the user
    createHome = false;

    # The account UID
    uid = 993;

    # The set of packages that should be made available to the user
    packages = with pkgs; [
      pv
      mbuffer
      lzop
      zstd
    ];

    # The path to the user's shell
    shell = getExe pkgs.bash;

    # A list of files each containing one OpenSSH public key that should be added
    # to the user's authorized keys
    openssh.authorizedKeys.keyFiles = [
      (relativeToRoot "nixos-configurations/omer-desktop/syncoid.pub")
    ];
  };

  # Additional groups to be created automatically by the system
  users.groups.syncoid = mkIf (config._module.args.impermanence) {
    # The group GID
    gid = 993;
  };
}
