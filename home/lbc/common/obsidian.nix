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

      cssSnippets = [
        {
          name = "pdf-style";
          enable = true;
          text = ''
            /* Centered images with rounded corners */
            .markdown-preview-view img,
            .markdown-source-view.mode-source img,
            .cm-s-obsidian img,
            .print img {
              display: block;
              margin-left: auto;
              margin-right: auto;
              border-radius: 12px;
            }

            .image-embed {
              display: block;
              text-align: center;
            }
          '';
        }
      ];
    };

    vaults = {
      "Documents/obsidian-theme".enable = true;
    };
  };
}
