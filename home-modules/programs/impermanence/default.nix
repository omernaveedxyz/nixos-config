{ config, impermanence, ... }:
{
  imports = [ impermanence.nixosModules.home-manager.impermanence ];

  # Allows other users, such asa root, to access files through the bind
  # mounted directories listed in directories
  home.persistence."/persistent/home/${config.home.username}".allowOther = true;
}
