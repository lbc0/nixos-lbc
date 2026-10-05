{pkgs, ...}: {
  programs.obsidian = {
    enable = true;

    vaults."platformSec" = {
      target = "Obsidian/platformSec";

      settings.appearance.cssTheme = "Catppuccin";
    };

    defaultSettings.themes = with pkgs.obsidianThemes; [catppuccin];
  };
}
