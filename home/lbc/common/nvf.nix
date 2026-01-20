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
        autocomplete.nvim-cmp.enable = true;
        telescope.enable = true;

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
            action = "<cmd>t<CR>";
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
