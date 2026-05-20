{
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        viAlias = true;
        vimAlias = true;

        # --- LSP ---lk
        lsp = {
          enable = true;
          formatOnSave = true;
          lspSignature.enable = true;
          servers.nil.settings.nil.nix.flake.autoArchive = true;
        };

        # --- Autocomplete ---
        autocomplete.nvim-cmp.enable = true;

        # Nvim BuffrLine
        tabline.nvimBufferline = {
          enable = true;
          mappings.closeCurrent = "<leader>be";
        };

        # --- Languages ---
        languages = {
          enableFormat = true;
          enableTreesitter = true;

          python = {
            enable = true;
            format.enable = true;
            lsp.servers = ["pyright"]; # list now
            treesitter.enable = true;
          };

          go = {
            enable = true;
            format.enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };

          nix = {
            enable = true;
            treesitter.enable = true;
          };
        };

        # --- Git ---
        git = {
          enable = true;
          gitsigns.enable = true;
          vim-fugitive.enable = true;
        };

        # --- Status line ---
        statusline.lualine = {
          enable = true;
          theme = "tokyonight";
        };

        # --- Telescope (fuzzy finding) ---
        telescope.enable = true;

        # --- Terminal ---
        terminal.toggleterm = {
          enable = true;
          lazygit.enable = true; # nice git TUI inside Neovim
        };

        # --- File tree ---
        filetree.nvimTree = {
          enable = true;
          openOnSetup = false;
          setupOpts.modified = {
            enable = true;
            show_on_dirs = true;
            show_on_open_dirs = true;
          };
        };

        # --- Motion ---
        utility.motion.flash-nvim = {
          enable = true;
          mappings.jump = "m";
        };

        # --- Visuals ---
        theme = {
          enable = true;
          name = "tokyonight";
          style = "night";
        };

        visuals = {
          nvim-web-devicons.enable = true; # file icons
          indent-blankline.enable = true; # indent guides
          highlight-undo.enable = true;
          nvim-cursorline.enable = true;
        };

        # --- Clipboard ---
        clipboard = {
          enable = true;
          providers.wl-copy.enable = true;
          registers = "unnamedplus";
        };

        # --- Options ---
        options = {
          shiftwidth = 2;
          tabstop = 2;
          number = true;
          relativenumber = true;
          signcolumn = "yes"; # keeps LSP gutter stable
          scrolloff = 8;
        };

        binds.whichKey = {
          enable = true;
          setupOpts = {
            preset = "modern";
            win = {
              border = "rounded";
              #width = 0.33;
              #height = {
              #  min = 4;
              #  max = 25;
              #};
            };
          };
        };

        luaConfigRC = {
          nvimtree-keys = ''
            vim.api.nvim_create_autocmd("FileType", {
              pattern = "NvimTree",
              callback = function(args)
                local api = require("nvim-tree.api")
                vim.keymap.set("n", "l", api.node.open.edit, { buffer = args.buf, silent = true })
                vim.keymap.set("n", "h", api.node.navigate.parent_close, { buffer = args.buf, silent = true })
              end,
            })
          '';

          go-highlight = ''
            -- Enable semantic tokens (richer LSP-based coloring)
            vim.api.nvim_create_autocmd("LspAttach", {
              callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client then
                  client.server_capabilities.semanticTokensProvider = client.server_capabilities.semanticTokensProvider
                end
              end,
            })
          '';

          indentation = ''
            vim.api.nvim_create_autocmd("FileType", {
              pattern = { "go", "nix", "python" },
              callback = function()
                vim.opt_local.indentexpr = ""
                vim.opt_local.autoindent = true
                vim.opt_local.preserveindent = true
              end,
            })
          '';

          tabline = ''
            vim.opt.showtabline = 2  -- always show tabline
          '';

          terminal-keymap = ''
            vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { silent = true })
          '';

          which-key = ''
            local wk = require("which-key")
            wk.add({
              { "<leader>f", group = "find/file" },
              { "<leader>t", group = "terminal/tabs" },
              { "<leader>w", group = "save" },
              { "<leader>q", group = "quit" },
              { "<leader>c", group = "code/format" },
              { "<leader>r", group = "rename" },
              { "g",         group = "goto" },
              { "<leader>s", group = "splits" },
            })
          '';

          bufferline-path = ''
            vim.defer_fn(function()
               require("bufferline").setup(vim.tbl_deep_extend("force", {}, {
                 options = {
                   name_formatter = function(buf)
                     local cwd = vim.fn.getcwd()
                     local path = buf.path
                     -- Make path relative to cwd
                     local rel = path:gsub("^" .. vim.pesc(cwd) .. "/", "")
                     -- Split into parts
                     local parts = vim.split(rel, "/")
                     -- Shorten all parts except the last (filename)
                     local shortened = {}
                     for i, part in ipairs(parts) do
                       if i < #parts then
                         table.insert(shortened, part:sub(1, 1))
                       else
                         table.insert(shortened, part)
                       end
                     end
                     return table.concat(shortened, "/")
                   end,
                 },
               }))
             end, 100)
          '';

          nvimtree-highlight = ''
            vim.api.nvim_create_autocmd("BufEnter", {
              callback = function()
                local buf = vim.api.nvim_get_current_buf()
                local modified = vim.api.nvim_get_option_value("modified", { buf = buf })
                -- highlight modified files in tree
                vim.api.nvim_set_hl(0, "NvimTreeModifiedFile", { fg = "#e0af68", bold = true })
                vim.api.nvim_set_hl(0, "NvimTreeModifiedIcon", { fg = "#e0af68" })
              end,
            })
          '';
        };

        # --- Keymaps ---
        keymaps = [
          # File explorer
          {
            key = "<leader>e";
            mode = "n";
            silent = true;
            action = "<cmd>NvimTreeToggle<CR>";
          }

          # Telescope
          {
            key = "<leader>ff";
            mode = "n";
            silent = true;
            action = "<cmd>Telescope find_files<CR>";
          }
          {
            key = "<leader>fg";
            mode = "n";
            silent = true;
            action = "<cmd>Telescope live_grep<CR>";
          }
          {
            key = "<leader>fb";
            mode = "n";
            silent = true;
            action = "<cmd>Telescope buffers<CR>";
          }

          # Terminal
          {
            key = "<leader>tt";
            mode = "n";
            silent = true;
            action = "<cmd>ToggleTerm direction=horizontal<CR>";
          }
          {
            key = "<leader>tg";
            mode = "n";
            silent = true;
            action = "<cmd>LazyGit<CR>";
          }

          # LSP (these complement nvf's built-in LSP keymaps)
          {
            key = "<leader>ca";
            mode = "n";
            silent = true;
            action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
          }
          {
            key = "<leader>rn";
            mode = "n";
            silent = true;
            action = "<cmd>lua vim.lsp.buf.rename()<CR>";
          }
          {
            key = "gd";
            mode = "n";
            silent = true;
            action = "<cmd>lua vim.lsp.buf.definition()<CR>";
          }
          {
            key = "K";
            mode = "n";
            silent = true;
            action = "<cmd>lua vim.lsp.buf.hover()<CR>";
          }

          # Buffer nav
          {
            key = "<Tab>";
            mode = "n";
            silent = true;
            action = "<cmd>bnext<CR>";
          }
          {
            key = "<S-Tab>";
            mode = "n";
            silent = true;
            action = "<cmd>bprev<CR>";
          }

          # Switch focus
          # Normal mode - all directions
          {
            key = "<C-h>";
            mode = "n";
            silent = true;
            action = "<C-w>h";
          }
          {
            key = "<C-l>";
            mode = "n";
            silent = true;
            action = "<C-w>l";
          }
          {
            key = "<C-j>";
            mode = "n";
            silent = true;
            action = "<C-w>j";
          }
          {
            key = "<C-k>";
            mode = "n";
            silent = true;
            action = "<C-w>k";
          }
          {
            key = "<C-p>"; # previous window
            mode = "n";
            silent = true;
            action = "<C-w>p";
          }

          # Terminal mode - same keys work inside terminal
          {
            key = "<C-h>";
            mode = "t";
            silent = true;
            action = "<C-\\><C-n><C-w>h";
          }
          {
            key = "<C-l>";
            mode = "t";
            silent = true;
            action = "<C-\\><C-n><C-w>l";
          }
          {
            key = "<C-j>";
            mode = "t";
            silent = true;
            action = "<C-\\><C-n><C-w>j";
          }
          {
            key = "<C-k>";
            mode = "t";
            silent = true;
            action = "<C-\\><C-n><C-w>k";
          }
          {
            key = "<C-p>";
            mode = "t";
            silent = true;
            action = "<C-\\><C-n><C-w>p";
          }

          # Save and quit
          {
            key = "<leader>wq";
            mode = "n";
            silent = true;
            action = "<cmd>wqa<CR>";
          }
          # Quit without save
          {
            key = "<leader>qq";
            mode = "n";
            silent = true;
            action = "<cmd>qa!<CR>";
          }
          # Just save (bonus)
          {
            key = "<leader>ww";
            mode = "n";
            silent = true;
            action = "<cmd>w<CR>";
          }

          # New empty tab
          {
            key = "<leader>tn";
            mode = "n";
            silent = true;
            action = "<cmd>tabnew<CR>";
          }
          # Close current tab
          {
            key = "<leader>tc";
            mode = "n";
            silent = true;
            action = "<cmd>tabclose<CR>";
          }
          # Next / prev tab
          {
            key = "<leader>t]";
            mode = "n";
            silent = true;
            action = "<cmd>tabnext<CR>";
          }
          {
            key = "<leader>t[";
            mode = "n";
            silent = true;
            action = "<cmd>tabprev<CR>";
          }

          # Format entire file
          {
            key = "<leader>cf";
            mode = "n";
            silent = true;
            action = "<cmd>lua vim.lsp.buf.format({ async = true })<CR>";
          }

          {
            key = "<CR>";
            mode = "n";
            silent = true;
            action = "i<CR><Esc>";
          }

          # Split windows
          {
            key = "<leader>sv";
            mode = "n";
            silent = true;
            action = "<cmd>vsplit<CR>";
          } # vertical split
          {
            key = "<leader>sh";
            mode = "n";
            silent = true;
            action = "<cmd>split<CR>";
          } # horizontal split
          {
            key = "<leader>sc";
            mode = "n";
            silent = true;
            action = "<cmd>close<CR>";
          } # close current split
          # Resize splits
          {
            key = "<C-Left>";
            mode = "n";
            silent = true;
            action = "<cmd>vertical resize -2<CR>";
          }
          {
            key = "<C-Right>";
            mode = "n";
            silent = true;
            action = "<cmd>vertical resize +2<CR>";
          }
          {
            key = "<C-Up>";
            mode = "n";
            silent = true;
            action = "<cmd>resize +2<CR>";
          }
          {
            key = "<C-Down>";
            mode = "n";
            silent = true;
            action = "<cmd>resize -2<CR>";
          }
        ];
      };
    };
  };
}
