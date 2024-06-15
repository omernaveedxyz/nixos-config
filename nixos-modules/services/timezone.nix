{
  # The location provider to use for determining your location
  location.provider = "geoclue2";

  # Enable automatic-timezoned, simple daemon for keeping the system timezone 
  # up-to-date based on the current location
  services.automatic-timezoned.enable = true;
}
