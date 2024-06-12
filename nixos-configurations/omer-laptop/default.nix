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
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usb_storage"
    "sd_mod"
    "rtsx_pci_sdmmc"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  networking.hostName = "omer-laptop";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/d79d9ed3-f639-4219-a7b9-08ac0292f92a";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6C96-EA1C";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.omer = {
    isNormalUser = true;
    description = "Omer Naveed";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      #  thunderbird
    ];
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
