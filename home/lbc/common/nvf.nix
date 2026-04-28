{
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        viAlias = true;
        vimAlias = true;

        # --- LSP ---
        lsp = {
          enable = true;
          formatOnSave = true;
          lspSignature.enable = true;
        };

        # --- Autocomplete ---
        autocomplete.nvim-cmp.enable = true;

        # --- Languages ---
        languages = {
          enableFormat = true;
          enableTreesitter = true;

          python = {
            enable = true;
            format.enable = true;
            lsp.servers = ["pyright"]; # list now
          };

          go = {
            enable = true;
            format.enable = true;
            lsp.enable = true;
          };

          nix.enable = true;
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
        };

        # --- Motion ---
        utility.motion.flash-nvim = {
          enable = true;
          mappings.jump = "z";
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

        luaConfigRC.nvimtree-keys = ''
          vim.api.nvim_create_autocmd("FileType", {
            pattern = "NvimTree",
            callback = function(args)
              local api = require("nvim-tree.api")
              vim.keymap.set("n", "l", api.node.open.edit, { buffer = args.buf, silent = true })
              vim.keymap.set("n", "h", api.node.navigate.parent_close, { buffer = args.buf, silent = true })
            end,
          })
        '';

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
        ];
      };
    };
  };
}
