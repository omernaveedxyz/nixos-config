{
  services.postgresql = {
    # Whether to enable PostgreSQL Server
    enable = true;
  };

  # Files and directories to persist across ephemeral boots
  environment.persistence."/persistent" = {
    # All directories you want to link or bind to persistent storage
    directories = [
      {
        directory = "/var/lib/postgresql";
        user = "postgres";
        group = "postgres";
        mode = "0755";
      }
    ];
  };
}
