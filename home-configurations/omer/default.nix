{
  imports = [
    ./common/programs/alacritty
    ./common/programs/android-studio
    ./common/programs/bash
    ./common/programs/bashmount
    ./common/programs/bat
    ./common/programs/btop
    ./common/programs/chromium
    ./common/programs/direnv
    ./common/programs/electrum
    ./common/programs/firefox
    ./common/programs/foot
    ./common/programs/fzf
    ./common/programs/git
    ./common/programs/gpg
    ./common/programs/hyprland
    ./common/programs/hyprlock
    ./common/programs/hyprpicker
    ./common/programs/impermanence
    ./common/programs/kitty
    ./common/programs/lf
    ./common/programs/monero
    ./common/programs/mpv
    ./common/programs/neovim
    ./common/programs/nix
    ./common/programs/pistol
    ./common/programs/proton
    ./common/programs/rofi
    ./common/programs/ssh
    ./common/programs/stylix
    ./common/programs/sway
    ./common/programs/swaylock
    ./common/programs/tmux
    ./common/programs/vimiv
    ./common/programs/virt-manager
    ./common/programs/waybar
    ./common/programs/waypipe
    ./common/programs/xdg
    ./common/programs/yt-dlp
    ./common/programs/yubikey
    ./common/programs/zathura

    ./common/services/clipman
    ./common/services/flameshot
    ./common/services/gammastep
    ./common/services/gpg-agent
    ./common/services/hypridle
    ./common/services/mpris-proxy
    ./common/services/swayidle
    ./common/services/swaync
    ./common/services/wireplumber
    ./common/services/wob
    ./common/services/xdg-portals
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
