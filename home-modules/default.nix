{
  imports = [
    ./programs/bash.nix
    ./programs/direnv.nix
    ./programs/firefox.nix
    ./programs/foot.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/gpg.nix
    ./programs/impermanence.nix
    ./programs/lf.nix
    ./programs/neovim.nix
    ./programs/nix.nix
    ./programs/ssh.nix
    ./programs/sway.nix
    ./programs/swaylock.nix
    ./programs/tmux.nix
    ./programs/xdg.nix
    ./programs/yubikey.nix

    ./services/gpg-agent.nix
    ./services/swayidle.nix
    ./services/swaync.nix
    ./services/wireplumber.nix
  ];

  # Modify and extend existing Nixpkgs collection
  nixpkgs.overlays = with (import ./overlays); [
    additions
    modifications
  ];

  # It is occasionally necessary for Home Manager to change configuration defaults 
  # in a way that is incompatible with stateful data. This could, for example, include 
  # switching the default data format or location of a file.
  #
  # The state version indicates which default settings are in effect and will therefore 
  # help avoid breaking program configurations. Switching to a higher state version 
  # typically requires performing some manual steps, such as data conversion or moving files.
  home.stateVersion = "24.05";
}
