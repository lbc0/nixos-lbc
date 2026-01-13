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

        theme = {
          enable = true;
          name = "gruvbox";
          style = "dark";
        };

        languages = {
          nix.enable = true;
        };
      };
    };
  };
}
