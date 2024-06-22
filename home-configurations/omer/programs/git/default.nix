{ config, lib, ... }:
let
  inherit (lib) mkIf;
in
{
  programs.git = mkIf (config.programs.git.enable) {
    # Default user email to use
    userEmail = "me@omernaveed.dev";

    # Default user name to use
    userName = "Omer Naveed";

    # Options related to signing commits using GnuPG
    signing = {
      # Whether commits and tags should be signed by default
      signByDefault = true;

      # The default GPG signing key fingerprint
      key = "0eefa4cacf0b32cbab38bb06f478b0d65409a857";
    };
  };
}
