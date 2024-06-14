{
  hardware.bluetooth = {
    # Whether to enable support for Bluetooth
    enable = true;

    # Whether to power up the default Bluetooth controller on boot
    powerOnBoot = true;
  };

  # Files and directories to persistent across ephemeral boots
  environment.persistence."/persistent" = {
    # All directories you want to link or bind to persistent storage
    directories = [
      {
        directory = "/var/lib/bluetooth";
        user = "root";
        group = "root";
        mode = "0700";
      }
    ];
  };
}
