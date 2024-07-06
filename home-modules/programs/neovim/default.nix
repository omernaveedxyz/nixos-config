{
  config,
  lib,
  pkgs,
  nixvim,
  ...
}:
let
  inherit (lib) mkIf;
in
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

      # When and how to draw the signcolumn
      signcolumn = "yes";

      # Vim automatically saves undo history to an undo file when writing a buffer to a file, and restores undo history from the same file on buffer read
      undofile = true;

      # Use the appropriate number of spaces to insert a <Tab>
      expandtab = true;

      # Number of spaces that a <Tab> in the file counts for
      tabstop = 2;

      # Number of spaces to use for each step of (auto)indent
      shiftwidth = 2;

      # Number of spaces that a <Tab> counts for while performing editing operations, like inserting a <Tab> or using <BS>
      softtabstop = -1;

      # When on, a <Tab> in front of a line inserts blanks according to 'shiftwidth'
      smarttab = true;
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

          # Markdown language server
          marksman = {
            # Whether to enable marksman for Markdown
            enable = true;
          };
        };
      };

      # Format files automatically
      lsp-format = {
        # Whether to enable lsp-format.nvim
        enable = true;
      };

      # Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua
      none-ls = {
        # Whether to enable none-ls.nvim
        enable = true;

        # List of sources by which to perform various functions
        sources = {
          # List of sources by which to format files
          formatting = {
            # Check code for common misspellings
            codespell = {
              # Whether to enable the codespell formatting source for none-ls
              enable = true;
            };

            # The official (but not yet stable) formatter for Nix code
            nixfmt = {
              # Whether to enable the nixfmt formatting source for none-ls
              enable = true;

              # Package to use for nixfmt by none-ls
              package = pkgs.nixfmt-rfc-style;
            };

            # Prettier, as a daemon, for improved formatting speed
            prettierd = {
              # Whether to enable the prettierd formatting source for none-ls
              enable = true;
            };

            # A shell formatter (sh/bash/mksh)
            shfmt = {
              # Whether to enable the shfmt formatting source for none-ls
              enable = true;
            };
          };
        };
      };

      # Highlight, list and search todo comments in your projects
      todo-comments = {
        # Whether to enable todo-comments
        enable = true;
      };

      # Nvim Treesitter configurations and abstraction layer
      treesitter = {
        # Whether to enable tree-sitter syntax highlighting
        enable = true;
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

  # Files and directories to persistent across ephemeral boots
  home.persistence."/persistent/home/${config.home.username}" =
    mkIf (config._module.args.impermanence)
      {
        # All directories you want to link or bind to persistent storage
        directories = [ ".local/state/nvim/undo" ];
      };
}
