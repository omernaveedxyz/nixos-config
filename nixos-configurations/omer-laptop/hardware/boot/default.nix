{
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
}
