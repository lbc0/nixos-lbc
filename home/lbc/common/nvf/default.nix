{...}: {
  programs.nvf = {
    enable = true;
    settings.vim = {
      viAlias = true;
      vimAlias = true;

      # Core modules
      imports = [
        ./options.nix
        ./keymaps.nix
        ./lua.nix
        ./languages.nix
      ];

      # --- LSP ---
      lsp = {
        enable = true;
        formatOnSave = true;
        lspSignature.enable = true;
        servers.nil.settings.nil.nix.flake.autoArchive = true;
      };

      # --- Autocomplete ---
      autocomplete.nvim-cmp.enable = true;

      # --- Tabline ---
      tabline.nvimBufferline = {
        enable = true;
        mappings.closeCurrent = "<leader>be";
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

      # --- Fuzzy finding ---
      telescope.enable = true;

      # --- Terminal ---
      terminal.toggleterm = {
        enable = true;
        lazygit.enable = true;
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

      # --- Theme ---
      theme = {
        enable = true;
        name = "tokyonight";
        style = "night";
      };

      # --- Visuals ---
      visuals = {
        nvim-web-devicons.enable = true;
        indent-blankline.enable = true;
        highlight-undo.enable = true;
        nvim-cursorline.enable = true;
      };

      # --- Clipboard ---
      clipboard = {
        enable = true;
        providers.wl-copy.enable = true;
        registers = "unnamedplus";
      };

      # --- Which-key ---
      binds.whichKey = {
        enable = true;
        setupOpts = {
          preset = "modern";
          win.border = "rounded";
        };
      };
    };
  };
}
