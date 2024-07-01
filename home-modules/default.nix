{
  imports = [
    ./programs/alacritty
    ./programs/bash
    ./programs/bashmount
    ./programs/btop
    ./programs/chromium
    ./programs/direnv
    ./programs/firefox
    ./programs/foot
    ./programs/fzf
    ./programs/git
    ./programs/gpg
    ./programs/hyprland
    ./programs/hyprlock
    ./programs/hyprpicker
    ./programs/impermanence
    ./programs/kitty
    ./programs/lf
    ./programs/mpv
    ./programs/neovim
    ./programs/nix
    ./programs/pistol
    ./programs/proton
    ./programs/rofi
    ./programs/ssh
    ./programs/stylix
    ./programs/sway
    ./programs/swaylock
    ./programs/tmux
    ./programs/vimiv
    ./programs/virt-manager
    ./programs/waybar
    ./programs/xdg
    ./programs/yt-dlp
    ./programs/yubikey

    ./services/clipman
    ./services/flameshot
    ./services/gammastep
    ./services/gpg-agent
    ./services/hypridle
    ./services/mpris-proxy
    ./services/swayidle
    ./services/swaync
    ./services/wireplumber
    ./services/wob
    ./services/xdg-portals
  ];

  # Modify and extend existing Nixpkgs collection
  nixpkgs.overlays = with (import ./overlays); [
    additions
    modifications
  ];

  # It is occasionally necessary for Home Manager to change configuration defaults 
  # in a way that is incompatible with stateful data. This could, for example, include 
  # switching the default data format or location of a file.
  #
  # The state version indicates which default settings are in effect and will therefore 
  # help avoid breaking program configurations. Switching to a higher state version 
  # typically requires performing some manual steps, such as data conversion or moving files.
  home.stateVersion = "24.05";
}
