{ nixvim, ... }:
{
  imports = [ nixvim.homeManagerModules.nixvim ];

  programs.nixvim = {
    # Whether to enable nixvim
    enable = true;

    # Whether to enable nixvim as the default editor
    defaultEditor = true;

    # Symlink vi to nvim binary
    viAlias = true;

    # Symlink vim to nvim binary
    vimAlias = true;

    # Alias vimdiff to nvim -d
    vimdiffAlias = true;

    clipboard = {
      # Sets the register to use for the clipboard
      register = "unnamedplus";

      # Package(s) to use as the clipboard provider
      providers.wl-copy = {
        # Whether to enable wl-copy
        enable = true;
      };
    };

    # Configure plugins to install in Nixvim
    plugins = {
      # A blazing fast and easy to configure neovim statusline plugin written in pure lua
      lualine = {
        # Whether to enable lualine
        enable = true;
      };

      # Dumb automatic fast indentation detection for Neovim written in Lua
      indent-o-matic = {
        # Whether to enable indent-o-matic
        enable = true;
      };
    };
  };
}
