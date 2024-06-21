{
  programs.neovim = {
    # Whether to enable neovim
    enable = true;

    # Whether to configure nvim as the default editor using the EDITOR environment variable.
    defaultEditor = true;

    # Symlink vi to nvim binary
    viAlias = true;

    # Symlink vim to nvim binary
    vimAlias = true;

    # Alias vimdiff to nvim -d
    vimdiffAlias = true;
  };
}
