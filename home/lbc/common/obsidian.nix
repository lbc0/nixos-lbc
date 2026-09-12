{pkgs, ...}: {
  programs.obsidian = {
    enable = true;

    defaultSettings = {
      app = {
        alwaysUpdateLinks = true;
        attachmentFolderPath = "./x";
      };
      appearance = {
        cssTheme = "AnuPpuccin";
        theme = "moonstone";
      };
      themes = with pkgs.obsidianThemes; [
        anuppuccin
      ];
    };

    vaults = {
      "Documents/Obsidian".enable = true;
      "Documents/Ideaverse".enable = true;
    };
  };
}
