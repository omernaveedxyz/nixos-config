{
  imports = [
    ./hardware/bluetooth
    ./hardware/disko
    ./hardware/graphics
    ./hardware/impermanence
    ./hardware/lanzaboote
    ./hardware/networking
    ./hardware/systemd-boot
    ./hardware/systemd
    ./hardware/virtualisation

    ./programs/adb
    ./programs/dconf
    ./programs/fuse
    ./programs/nix
    ./programs/pam
    ./programs/plymouth
    ./programs/sops
    ./programs/users

    ./services/dbus
    ./services/greetd
    ./services/openssh
    ./services/pcscd
    ./services/pipewire
    ./services/sanoid
    ./services/udisks2
    ./services/zfs
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
