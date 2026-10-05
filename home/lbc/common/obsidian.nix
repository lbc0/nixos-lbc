{pkgs, ...}: {
  programs.obsidian = {
    enable = true;

    vaults."platformSec" = {
      target = "Obsidian/platformSec";

      settings = {
        appearance.cssTheme = "Soft Paper";

        app = {
          alwaysUpdateLinks = true;
          attachmentFolderPath = "./x";
          newFileLocation = "current";
        };
      };
    };

    defaultSettings.themes = with pkgs.obsidianThemes; [soft-paper];
  };
}
