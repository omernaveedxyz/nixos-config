{
  imports = [
    ./programs/alacritty
    ./programs/android-studio
    ./programs/bash
    ./programs/bashmount
    ./programs/bat
    ./programs/btop
    ./programs/chromium
    ./programs/direnv
    ./programs/electrum
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
    ./programs/monero
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
    ./programs/waypipe
    ./programs/xdg
    ./programs/yt-dlp
    ./programs/yubikey
    ./programs/zathura

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

  # Additional arguments passed to each module
  _module.args = {
    impermanence = true;
    desktop = "hyprland";
    terminal = "foot";
    browser = "firefox";
  };

  # The user’s username
  home.username = "omer";
}
