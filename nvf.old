{
  programs.nvf = {
    enable = true;
    
    # Your settings need to go into the settings attribute set
    # most settings are documented in the appendix
    settings = {
      vim = {
        viAlias = true;
        vimAlias = true;
        lsp.enable = true;
        telescope.enable = true;

        utility.motion.flash-nvim = {
          enable = true;
          mappings.jump = "z";
        };

        clipboard = {
          enable = true;
          providers.wl-copy.enable = true;
          registers = "unnamedplus";
        };

        filetree.nvimTree = {
          enable = true;
          openOnSetup = false;
        };

        options = {
          shiftwidth = 2;
          
        };

        keymaps = [
          {
            key = "<leader>e";
            mode = "n";
            silent = true;
            action = "<cmd>Ex<CR>";
          }
          # {
          #   key = "<leader>l";
          #   mode = ["n" "x"];
          #   silent = true;
          #   action = "<cmd>cnext<CR>";
          # }
        ];

        theme = {
          enable = true;
          name = "tokyonight";
          style = "night";
        };

        languages = {
          nix.enable = true;
          python.enable = true;
        };
      };
    };
  };
}
