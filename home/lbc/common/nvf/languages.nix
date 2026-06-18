{
  languages = {
    enableFormat = true;
    enableTreesitter = true;

    python = {
      enable = true;
      format.enable = true;
      lsp.servers = ["pyright"];
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
}
