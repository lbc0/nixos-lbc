{pkgs, ...}: {
  programs.obsidian = {
    enable = true;

    defaultSettings = {
      app = {
        vimMode = true;
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

      communityPlugins = with pkgs.obsidianPlugins; [
        obsidian-vimrc-support
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
      "Obsidian/platformSec".enable = true;
    };
  };

  home.file."Obsidian/platformSec/.obsidian/hotkeys.json".text = ''
    {
      "app:toggle-left-sidebar": [{ "modifiers": ["Alt"], "key": "E" }],
      "app:toggle-right-sidebar": [{ "modifiers": ["Alt"], "key": "R" }],
      "editor:focus": [{ "modifiers": ["Alt"], "key": "F" }],

      "workspace:split-vertical": [{ "modifiers": ["Alt"], "key": "S" }],
      "workspace:split-horizontal": [{ "modifiers": ["Alt", "Shift"], "key": "S" }],

      "editor:focus-left": [{ "modifiers": ["Alt"], "key": "H" }],
      "editor:focus-bottom": [{ "modifiers": ["Alt"], "key": "J" }],
      "editor:focus-top": [{ "modifiers": ["Alt"], "key": "K" }],
      "editor:focus-right": [{ "modifiers": ["Alt"], "key": "L" }]
    }
  '';

  home.file."Obsidian/platformSec/.obsidian.vimrc".text = ''
    " ── Commands ──
    exmap togglefold obcommand editor:toggle-fold
    exmap foldall obcommand editor:fold-all
    exmap unfoldall obcommand editor:unfold-all
    exmap foldmore obcommand editor:fold-more
    exmap foldless obcommand editor:fold-less

    " ── Folds ──
    nmap fa :togglefold<CR>
    nmap fM :foldall<CR>
    nmap fL :unfoldall<CR>
    nmap fm :foldmore<CR>
    nmap fl :foldless<CR>

    " ── Misc ──
    nnoremap <CR> i<CR><Esc>
  '';
}
