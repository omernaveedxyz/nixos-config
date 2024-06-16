{ config, lib, ... }:
let
  inherit (builtins) readDir;
  inherit (lib) attrNames;
in
{
  programs.gpg = {
    # Whether to enable GnuPG
    enable = true;

    # Directory to store keychains and configuration
    homedir = "${config.xdg.dataHome}/gnupg";

    # If set to false, the path $GNUPGHOME/pubring.kbx will become an immutable
    # link to the Nix store, denying modifications
    mutableKeys = false;

    # If set to false, the path $GNUPGHOME/trustdb.gpg will be overwritten on
    # each activation, removing trust for any unmanaged keys
    mutableTrust = false;

    # SCdaemon configuration options
    scdaemonSettings = {
      disable-ccid = true;
    };

    # A list of public keys to be imported into GnuPG
    publicKeys =
      [
        {
          source = ../../home-configurations/${config.home.username}/pubkey.asc;
          trust = 5;
        }
      ]
      ++ (map (name: {
        source = ../../nixos-configurations/${name}/pubkey.asc;
        trust = 1;
      }) (attrNames (readDir ../../nixos-configurations)));
  };

  # Files and directories to persistent across ephemeral boots
  home.persistence."/persistent/home/${config.home.username}" = {
    # All directories you want to link or bind to persistent storage
    directories = [ ".local/share/gnupg" ];
  };
}
