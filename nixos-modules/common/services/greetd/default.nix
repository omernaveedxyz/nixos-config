{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe mkIf;
in
{
  services.greetd = {
    # Whether to enable greetd
    enable = true;

    # Greetd configuration
    settings = {
      default_session = {
        command = "${getExe pkgs.greetd.tuigreet} --time --remember --remember-user-session";
        user = "greeter";
      };
    };
  };

  # Files and directories to persistent across ephemeral boots
  environment.persistence."/persistent" = mkIf (config._module.args.impermanence) {
    # All directories you want to link or bind to persistent storage
    directories = [
      {
        directory = "/var/cache/tuigreet";
        user = "tuigreet";
        group = "tuigreet";
        mode = "0755";
      }
    ];
  };
}
