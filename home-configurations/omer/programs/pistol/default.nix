{
  programs.pistol = {
    # Whether to enable file previewer for terminal file managers
    enable = true;

    # Associations written to the Pistol configuration at $XDG_CONFIG_HOME/pistol/pistol.conf
    associations = [
      {
        mime = "text/*";
        command = "bat --paging=never --color=always --plain %pistol-filename%";
      }
      {
        mime = "application/javascript";
        command = "bat --paging=never --color=always --plain %pistol-filename%";
      }
    ];
  };
}
