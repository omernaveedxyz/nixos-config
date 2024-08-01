{
  modulesPath,
  lib,
  nixos-hardware,
  ...
}:
let
  inherit (lib) mkDefault;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")

    nixos-hardware.nixosModules.dell-xps-15-7590
    nixos-hardware.nixosModules.common-gpu-nvidia-disable

    ./hardware/boot
    ./hardware/wireguard
  ];

  # Specifies the platform where the NixOS configuration will run
  nixpkgs.hostPlatform = mkDefault "x86_64-linux";

  # The 32-bit host ID of the machine, formatted as 8 hexadecimal characters
  networking.hostId = "2e298b6f";

  # The time zone used when displaying times and dates
  time.timeZone = "America/Chicago";

  # Additional arguments passed to each module
  _module.args = {
    device = "/dev/nvme0n1";
    secureboot = true;
    impermanence = true;
  };
}
