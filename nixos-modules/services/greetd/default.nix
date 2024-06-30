{ lib, pkgs, ... }:
let
  inherit (lib) getExe;
in
{
  services.greetd = {
    # Whether to enable greetd
    enable = true;

    # Greetd configuration
    settings = {
      default_session = {
        command = "${getExe pkgs.greetd.tuigreet} --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };
}
