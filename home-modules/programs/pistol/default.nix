{
  programs.pistol = {
    # Whether to enable file previewer for terminal file managers
    enable = true;
  };

  # Environment variables to always set at login
  home.sessionVariables = {
    PISTOL_CHROMA_FORMATTER = "terminal16m";
  };
}
