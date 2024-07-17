{
  config,
  lib,
  impermanence,
  ...
}:
let
  inherit (lib) replaceStrings;
in
{
  imports = [ impermanence.nixosModules.home-manager.impermanence ];

  # Additional arguments passed to each module in addition to ones like lib, config, and pkgs, modulesPath
  _module.args.relativeToHome = map (
    name:
    replaceStrings
      [
        "${config.home.homeDirectory}/"
        "~/"
      ]
      [
        ""
        ""
      ]
      name
  );

  # Allows other users, such asa root, to access files through the bind
  # mounted directories listed in directories
  home.persistence."/persistent/home/${config.home.username}".allowOther = true;
}
