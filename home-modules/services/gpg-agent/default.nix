{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  services.gpg-agent = {
    # Whether to enable gnupg private key agent
    enable = true;

    # Whether to enable socket of the gnupg key agent
    enableExtraSocket = true;

    # Whether to use gnupg key agent for ssh keys
    enableSshSupport = true;

    # Which pinentry interface to use
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  wayland.windowManager.sway = mkIf (config.wayland.windowManager.sway.enable) {
    # Sway configuration options
    config = {
      # List of commands that should be executed on specific windows
      window.commands = [
        {
          # Swaywm command to execute
          command = "floating enable, move position center, resize set width 50 ppt height 50 ppt, sticky, fullscreen disable";

          # Criteria of the windows on which command should be executed
          criteria = {
            class = "gcr-prompter";
          };
        }
      ];
    };
  };

  # Hyprland configuration written in Nix
  wayland.windowManager.hyprland = mkIf (config.wayland.windowManager.hyprland.enable) {
    settings = {
      windowrulev2 = [
        "float, class:^(gcr-prompter)"
        "center, class:^(gcr-prompter)"
        "size 50% 50%, class:^(gcr-prompter)"
        "pin, class:^(gcr-prompter)"
        "stayfocused, class:^(gcr-prompter)"
        "suppressevent fullscreen maximize active activatefocus, class:^(gcr-prompter)"
        "dimaround, class:^(gcr-prompter)"
      ];
    };
  };
}
