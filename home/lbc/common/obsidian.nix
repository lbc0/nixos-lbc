{pkgs, ...}: {
  programs.obsidian = {
    enable = true;

    defaultSettings = {
      app = {
        alwaysUpdateLinks = true;
        attachmentFolderPath = "./x";
      };
      appearance = {
        cssTheme = "Soft Paper";
        theme = "moonstone";
      };
      themes = with pkgs.obsidianThemes; [
        soft-paper
      ];
    };

    vaults = {
      "Documents/soft".enable = true;
    };
  };
}
