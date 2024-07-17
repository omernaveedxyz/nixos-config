{ lib, ... }:
let
  inherit (lib) attrValues;

  nixosModules = import ./modules;
in
{
  imports = [
    ./common/hardware/bluetooth
    ./common/hardware/disko
    ./common/hardware/graphics
    ./common/hardware/impermanence
    ./common/hardware/lanzaboote
    ./common/hardware/networking
    ./common/hardware/systemd-boot
    ./common/hardware/systemd
    ./common/hardware/virtualisation

    ./common/programs/adb
    ./common/programs/dconf
    ./common/programs/fuse
    ./common/programs/nix
    ./common/programs/pam
    ./common/programs/plymouth
    ./common/programs/sops
    ./common/programs/users

    ./common/services/dbus
    ./common/services/greetd
    ./common/services/openssh
    ./common/services/pcscd
    ./common/services/pipewire
    ./common/services/sanoid
    ./common/services/udisks2
    ./common/services/zfs
  ] ++ attrValues nixosModules;

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
