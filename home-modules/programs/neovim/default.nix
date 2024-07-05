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

    # The configuration options
    opts = {
      # Precede each line with its line number
      number = true;

      # Show the line number relative to the line with the cursor in front of each line
      relativenumber = true;

      # The case of normal letters is ignored
      ignorecase = true;

      # Override the 'ignorecase' option if the search pattern contains upper case characters
      smartcase = true;

      # When there is a previous search pattern, highlight all its matches
      hlsearch = false;

      # Minimal number of screen lines to keep above and below the cursor
      scrolloff = 10;

      # lines longer than the width of the window will wrap and displaying continues on the next line
      # When off lines will not wrap and only part of long lines will be displayed
      wrap = false;
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

      # Git integration for buffers
      gitsigns = {
        # Whether to enable gitsigns.nvim
        enable = true;
      };

      # Quickstart configs for Nvim LSP
      lsp = {
        # Whether to enable neovim’s built-in LSP
        enable = true;

        servers = {
          # Nix language server
          nil-ls = {
            # Whether to enable nil for Nix
            enable = true;
          };

          # Bash language server
          bashls = {
            # Whether to enable bashls for bash
            enable = true;
          };

          # HTML language server
          html = {
            # Whether to enable HTML language server
            enable = true;
          };

          # CSS language server
          cssls = {
            # Whether to enable cssls for CSS
            enable = true;
          };
        };
      };
    };

    # Autocmd definitions
    autoCmd = [
      {
        # The event or events to register this autocommand
        event = "TextYankPost";

        # A textual description of this autocommand
        desc = "Highlight when yanking (copying) text";

        # The autocommand group name or id to match against
        group = "highlight-yank";

        # Lua function which is called when this autocommand is triggered
        callback = {
          __raw = "function() vim.highlight.on_yank() end";
        };
      }
    ];

    # Autogroup definitions
    autoGroups = {
      highlight-yank = {
        # Clear existing commands if the group already exists
        clear = true;
      };
    };
  };
}
