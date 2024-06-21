{
  imports = [
    ./programs/git
    ./programs/stylix
  ];

  # Additional arguments passed to each module
  _module.args = {
    impermanence = true;
    desktop = "sway";
    terminal = "foot";
    browser = "firefox";
  };

  # The user’s username
  home.username = "omer";
}
