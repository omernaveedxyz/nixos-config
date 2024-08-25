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

    # Global variables
    globals = {
      # Define the leader key
      mapleader = " ";

      # Define the local leader key
      maplocalleader = " ";
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

    # Nixvim keymaps
    keymaps = [
      {
        action = {
          __raw = "vim.diagnostic.goto_prev";
        };
        key = "[d";
        mode = "n";
        options = {
          desc = "Go to previous [D]iagnostic message";
        };
      }
      {
        action = {
          __raw = "vim.diagnostic.goto_next";
        };
        key = "]d";
        mode = "n";
        options = {
          desc = "Go to next [D]iagnostic message";
        };
      }
      {
        action = {
          __raw = "vim.diagnostic.open_float";
        };
        key = "<leader>e";
        mode = "n";
        options = {
          desc = "Show diagnostic [E]rror messages";
        };
      }
      {
        action = {
          __raw = "vim.diagnostic.setloclist";
        };
        key = "<leader>q";
        mode = "n";
        options = {
          desc = "Open diagnostic [Q]uickfix list";
        };
      }
    ];

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

        # Options provided to the require('gitsigns').setup function
        settings = {
          signs = {
            add = {
              text = "+";
            };
            change = {
              text = "~";
            };
            delete = {
              text = "_";
            };
            topdelete = {
              text = "‾";
            };
            changedelete = {
              text = "~";
            };
          };
        };
      };

      # Quickstart configs for Nvim LSP
      lsp = {
        # Whether to enable neovim’s built-in LSP
        enable = true;

        # Lsp keymaps
        keymaps = {
          # Extra keymaps to register when an LSP is attached
          extra = [
            {
              action = {
                __raw = "require('telescope.builtin').lsp_definitions";
              };
              key = "gd";
              options = {
                desc = "[G]oto [D]efinition";
              };
            }
            {
              action = {
                __raw = "require('telescope.builtin').lsp_references";
              };
              key = "gr";
              options = {
                desc = "[G]oto [R]eferences";
              };
            }
            {
              action = {
                __raw = "require('telescope.builtin').lsp_implementations";
              };
              key = "gi";
              options = {
                desc = "[G]oto [I]mplementation";
              };
            }
            {
              action = {
                __raw = "require('telescope.builtin').lsp_type_definitions";
              };
              key = "<leader>D";
              options = {
                desc = "Type [D]efinition";
              };
            }
            {
              action = {
                __raw = "require('telescope.builtin').lsp_document_symbols";
              };
              key = "<leader>ds";
              options = {
                desc = "[D]ocument [S]ymbols";
              };
            }
            {
              action = {
                __raw = "require('telescope.builtin').lsp_dynamic_workspace_symbols";
              };
              key = "<leader>ws";
              options = {
                desc = "[W]orkspace [S]ymbols";
              };
            }
            {
              action = {
                __raw = "vim.lsp.buf.rename";
              };
              key = "<leader>rn";
              options = {
                desc = "[R]e[n]ame";
              };
            }
            {
              action = {
                __raw = "vim.lsp.buf.code_action";
              };
              key = "<leader>ca";
              options = {
                desc = "[C]ode [A]ction";
              };
            }
            {
              action = {
                __raw = "vim.lsp.buf.hover";
              };
              key = "K";
              options = {
                desc = "Hover Documentation";
              };
            }
            {
              action = {
                __raw = "vim.lsp.buf.declaration";
              };
              key = "gD";
              options = {
                desc = "[G]oto [D]eclaration";
              };
            }
          ];
        };

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

          # Typescript language server
          tsserver = {
            # Whether to enable tsserver for TypeScript
            enable = true;
          };

          # Javascript/Typescript langauge server
          eslint = {
            # Whether to enable Enable eslint
            enable = true;
          };

          # Golang language server
          gopls = {
            # Whether to enable gopls for Go
            enable = true;
          };

          # OCaml language server
          ocamllsp = {
            # Whether to enable ocamllsp for OCaml
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

      # A completion plugin for neovim coded in Lua
      cmp = {
        # Whether to enable nvim-cmp
        enable = true;

        # Options provided to the require('cmp').setup function
        settings = {
          # The sources to use
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "path"; }
            { name = "buffer"; }
          ];

          # The snippet expansion function
          snippet.expand = {
            __raw = "function(args) require('luasnip').lsp_expand(args.body) end";
          };

          # Cmp mappings declaration
          mapping = {
            __raw = ''
              cmp.mapping.preset.insert({
                -- Select the [n]ext item
                ['<C-n>'] = cmp.mapping.select_next_item(),
                -- Select the [p]revious item
                ['<C-p>'] = cmp.mapping.select_prev_item(),

                -- Scroll the documentation window [b]ack / [f]orward
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),

                -- Accept ([y]es) the completion.
                --  This will auto-import if your LSP supports it.
                --  This will expand snippets if the LSP sent a snippet.
                ['<C-y>'] = cmp.mapping.confirm { select = true },

                -- Manually trigger a completion from nvim-cmp.
                --  Generally you don't need this, because nvim-cmp will display
                --  completions whenever it has completion options available.
                ['<C-Space>'] = cmp.mapping.complete {},
              })
            '';
          };
        };
      };

      # Snippet Engine for Neovim written in Lua
      luasnip = {
        # Whether to enable luasnip
        enable = true;

        # List of custom vscode style snippets to load
        fromVscode = [ { } ];
      };

      # Set of preconfigured snippets for different languages
      friendly-snippets = {
        # Whether to enable friendly-snippets
        enable = true;
      };

      # Find, Filter, Preview, Pick
      telescope = {
        # Whether to enable telescope.nvim
        enable = true;

        # Extensions to enable for Telescope
        extensions = {
          # Whether to enable the fzf-native telescope extension
          fzf-native.enable = true;

          # Whether to enable the ui-select telescope extension
          ui-select.enable = true;
        };

        # Keymaps for telescope
        keymaps = {
          "<leader>sh" = {
            action = "help_tags";
            options = {
              desc = "[S]earch [H]elp";
            };
          };
          "<leader>sk" = {
            action = "keymaps";
            options = {
              desc = "[S]earch [K]eymaps";
            };
          };
          "<leader>sf" = {
            action = "find_files";
            options = {
              desc = "[S]earch [F]iles";
            };
          };
          "<leader>ss" = {
            action = "builtin";
            options = {
              desc = "[S]earch [S]elect Telescope";
            };
          };
          "<leader>sw" = {
            action = "grep_string";
            options = {
              desc = "[S]earch current [W]ord";
            };
          };
          "<leader>sg" = {
            action = "live_grep";
            options = {
              desc = "[S]earch by [G]rep";
            };
          };
          "<leader>sd" = {
            action = "diagnostics";
            options = {
              desc = "[S]earch [D]iagnostics";
            };
          };
          "<leader>sr" = {
            action = "resume";
            options = {
              desc = "[S]earch [R]esume";
            };
          };
          "<leader>s." = {
            action = "oldfiles";
            options = {
              desc = "[S]earch Recent Files (\".\" for repeat)";
            };
          };
          "<leader><leader>" = {
            action = "buffers";
            options = {
              desc = "[ ] Find existing buffers";
            };
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

  # Files and directories to persistent across ephemeral boots
  home.persistence."/persistent/home/${config.home.username}" =
    mkIf (config._module.args.impermanence)
      {
        # All directories you want to link or bind to persistent storage
        directories = config._module.args.relativeToHome [ "${config.xdg.stateHome}/nvim/undo" ];
      };
}
