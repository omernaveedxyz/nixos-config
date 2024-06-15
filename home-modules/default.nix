{ config, impermanence, ... }:
{
  imports = [
    impermanence.nixosModules.home-manager.impermanence

    ./programs/bash.nix
    ./programs/direnv.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/gpg.nix
    ./programs/lf.nix
    ./programs/neovim.nix
    ./programs/nix.nix
    ./programs/ssh.nix
    ./programs/tmux.nix
    ./programs/xdg.nix

    ./services/gpg-agent.nix
    ./services/wireplumber.nix
  ];

  # Modify and extend existing Nixpkgs collection
  nixpkgs.overlays = with (import ./overlays); [
    additions
    modifications
  ];

  # Allows other users, such asa root, to access files through the bind
  # mounted directories listed in directories
  home.persistence."/persistent/home/${config.home.username}".allowOther = true;

  # It is occasionally necessary for Home Manager to change configuration defaults 
  # in a way that is incompatible with stateful data. This could, for example, include 
  # switching the default data format or location of a file.
  #
  # The state version indicates which default settings are in effect and will therefore 
  # help avoid breaking program configurations. Switching to a higher state version 
  # typically requires performing some manual steps, such as data conversion or moving files.
  home.stateVersion = "24.05";
}
