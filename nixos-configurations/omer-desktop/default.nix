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

    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-pc-ssd
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

  # Additional arguments passed to each module
  _module.args.device = "/dev/nvme0n1";

  ###
  ###
  ###

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "omer";
  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Install firefox.
  programs.firefox.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.git.enable = true;
  services.udev.packages = [ pkgs.yubikey-personalization ];
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  services.pcscd.enable = true;
}
