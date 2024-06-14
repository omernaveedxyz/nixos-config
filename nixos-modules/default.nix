{
  imports = [
    ./hardware/bluetooth.nix
    ./hardware/disko.nix
    ./hardware/impermanence.nix
    ./hardware/lanzaboote.nix
    ./hardware/networking.nix
    # ./hardware/systemd-boot.nix
    ./hardware/systemd.nix
    ./hardware/zfs.nix

    ./programs/colmena.nix
    ./programs/nix.nix
    ./programs/sops.nix
    ./programs/users.nix

    ./services/openssh.nix
  ];

  # Modify and extend existing Nixpkgs collection
  nixpkgs.overlays = with (import ./overlays); [
    additions
    modifications
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
