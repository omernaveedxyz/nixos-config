{
  hardware.bluetooth = {
    # Whether to enable support for Bluetooth
    enable = true;

    # Whether to power up the default Bluetooth controller on boot
    powerOnBoot = true;

    # Set configuration for system-wide bluetooth (/etc/bluetooth/main.conf)
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
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
