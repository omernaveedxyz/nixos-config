{ pkgs, ... }:
{
  boot = {
    plymouth = {
      # Whether to enable Plymouth boot splash screen
      enable = true;
    };

    # Parameters added to the kernel command line
    kernelParams = [
      "quiet"
      "udev.log_level=3"
    ];

    # The kernel console loglevel
    consoleLogLevel = 0;

    # Verbosity of the initrd
    initrd.verbose = false;
  };
}
