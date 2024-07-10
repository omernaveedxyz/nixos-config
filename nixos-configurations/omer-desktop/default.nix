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

    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-pc-ssd

    ./hardware/boot
    ./hardware/microvm
    ./hardware/mounts

    ./programs/acme

    ./services/nginx
    ./services/sanoid
    ./services/syncoid
  ];

  # Specifies the platform where the NixOS configuration will run
  nixpkgs.hostPlatform = mkDefault "x86_64-linux";

  # The name of the machine
  networking.hostName = "omer-desktop";

  # The 32-bit host ID of the machine, formatted as 8 hexadecimal characters
  networking.hostId = "001aa168";

  # The time zone used when displaying times and dates
  time.timeZone = "America/Chicago";

  # Additional arguments passed to each module
  _module.args = {
    device = "/dev/nvme0n1";
    secureboot = true;
    impermanence = true;
  };
}
