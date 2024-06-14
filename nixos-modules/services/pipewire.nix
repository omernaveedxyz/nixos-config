{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (pkgs) writeTextDir;
in
{
  services.pipewire = {
    # Whether to enable pipewire service
    enable = true;

    # Whether to enable ALSA support
    alsa.enable = true;

    # Whether to enable 32-bit ALSA support on 64-bit systems
    alsa.support32Bit = true;

    # Whether to enable PulseAudio server emulation
    pulse.enable = true;

    # List of packages the provide WirePlumber configuration
    # TODO: https://github.com/NixOS/nixpkgs/pull/292115
    wireplumber.configPackages = mkIf (config.hardware.bluetooth.enable) [
      (writeTextDir "share/wireplumber/bluetooth.lua.d/51-bluez-config.lua" ''
        bluez_monitor.properties = {
          ["bluez5.enable-sbc-xq"] = true,
          ["bluez5.enable-msbc"] = true,
          ["bluez5.enable-hw-volume"] = true,
          ["bluez5.headset-roles"] = "[hsp_hs hsp_ag hfp_hf hfp_ag]"
        }
      '')
    ];
  };

  # Whether to enable the RealtimeKit system service, which hands out realtime
  # scheduling priority to user processes on demand
  security.rtkit.enable = true;

  # Whether to enable the pulseaudio sound server
  hardware.pulseaudio.enable = false;
}
