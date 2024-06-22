{
  modulesPath,
  config,
  lib,
  pkgs,
  nixos-hardware,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")

    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-pc-ssd

    ./hardware/omer-media.nix
    ./hardware/omer-vault.nix
    ./hardware/omer-archive.nix
  ];

  # The set of kernel modules in the initial ramdisk used during the boot process
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];

  # List of modules that are always loaded by the initrd
  boot.initrd.kernelModules = [ ];

  # The set of kernel modules to be loaded in the second stage of the boot process
  boot.kernelModules = [ "kvm-amd" ];

  # A list of additional packages supplying kernel modules
  boot.extraModulePackages = [ ];

  # Specifies the platform where the NixOS configuration will run
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

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

  # Modules to help you handle persistent state on systems with ephemeral root storage
  environment.persistence."/persistent" = mkIf (config._module.args.impermanence) {
    # All files you want to link or bind to persistent storage
    files = [
      {
        file = "/etc/keyfile";
        parentDirectory = {
          user = "root";
          group = "root";
          mode = "0755";
        };
      }
    ];
  };
}
