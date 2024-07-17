{ config, lib, ... }:
let
  inherit (lib) mkIf;
in
{
  boot.loader = mkIf (!config._module.args.secureboot) {
    systemd-boot = {
      # Whether to enable the systemd-boot (formerly gummiboot) EFI boot manager
      enable = true;

      # Whether to allow editing the kernel command-line before boot
      editor = false;

      # Maximum number of latest generations in the boot menu
      configurationLimit = 16;
    };

    # Whether the installation process is allowed to modify EFI boot variables
    efi.canTouchEfiVariables = true;
  };
}
