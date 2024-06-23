{
  modulesPath,
  config,
  lib,
  pkgs,
  nixos-hardware,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")

    nixos-hardware.nixosModules.dell-xps-15-7590
    nixos-hardware.nixosModules.common-gpu-nvidia-disable

    ./hardware/wireguard
  ];

  # The set of kernel modules in the initial ramdisk used during the boot process
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usb_storage"
    "sd_mod"
    "rtsx_pci_sdmmc"
  ];

  # List of modules that are always loaded by the initrd
  boot.initrd.kernelModules = [ ];

  # The set of kernel modules to be loaded in the second stage of the boot process
  boot.kernelModules = [ "kvm-intel" ];

  # A list of additional packages supplying kernel modules
  boot.extraModulePackages = [ ];

  # Specifies the platform where the NixOS configuration will run
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # The name of the machine
  networking.hostName = "omer-laptop";

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
