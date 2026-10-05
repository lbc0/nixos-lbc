{pkgs, ...}: {
  programs.obsidian = {
    enable = true;

    defaultSettings = {
      app = {
        alwaysUpdateLinks = true;
        attachmentFolderPath = "./x";
        newFileLocation = "current";
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
      "Documents/obsidian-theme".enable = true;
    };
  };
}
