{
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        luaConfigRC = {
          nvimtree-keys = ''
            vim.api.nvim_create_autocmd("FileType", {
              pattern = "NvimTree",
              callback = function(args)
                local api = require("nvim-tree.api")
                vim.keymap.set("n", "l", api.node.open.edit, { buffer = args.buf, silent = true })
                vim.keymap.set("n", "h", api.node.navigate.parent_close, { buffer = args.buf, silent = true })
              end,
            })
          '';

          go-highlight = ''
            -- Enable semantic tokens (richer LSP-based coloring)
            vim.api.nvim_create_autocmd("LspAttach", {
              callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client then
                  client.server_capabilities.semanticTokensProvider = client.server_capabilities.semanticTokensProvider
                end
              end,
            })
          '';

          indentation = ''
            vim.api.nvim_create_autocmd("FileType", {
              pattern = { "go", "nix", "python" },
              callback = function()
                vim.opt_local.indentexpr = ""
                vim.opt_local.autoindent = true
                vim.opt_local.preserveindent = true
              end,
            })
          '';

          tabline = ''
            vim.opt.showtabline = 2  -- always show tabline
          '';

          terminal-keymap = ''
            vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { silent = true })
          '';

          which-key = ''
            local wk = require("which-key")
            wk.add({
              { "<leader>f", group = "find/file" },
              { "<leader>t", group = "terminal/tabs" },
              { "<leader>w", group = "save" },
              { "<leader>q", group = "quit" },
              { "<leader>c", group = "code/format" },
              { "<leader>r", group = "rename" },
              { "g",         group = "goto" },
              { "<leader>s", group = "splits" },
            })
          '';

          bufferline-path = ''
            vim.defer_fn(function()
               require("bufferline").setup(vim.tbl_deep_extend("force", {}, {
                 options = {
                   name_formatter = function(buf)
                     local cwd = vim.fn.getcwd()
                     local path = buf.path
                     -- Make path relative to cwd
                     local rel = path:gsub("^" .. vim.pesc(cwd) .. "/", "")
                     -- Split into parts
                     local parts = vim.split(rel, "/")
                     -- Shorten all parts except the last (filename)
                     local shortened = {}
                     for i, part in ipairs(parts) do
                       if i < #parts then
                         table.insert(shortened, part:sub(1, 1))
                       else
                         table.insert(shortened, part)
                       end
                     end
                     return table.concat(shortened, "/")
                   end,
                 },
               }))
             end, 100)
          '';

          nvimtree-highlight = ''
            vim.api.nvim_create_autocmd("BufEnter", {
              callback = function()
                local buf = vim.api.nvim_get_current_buf()
                local modified = vim.api.nvim_get_option_value("modified", { buf = buf })
                -- highlight modified files in tree
                vim.api.nvim_set_hl(0, "NvimTreeModifiedFile", { fg = "#e0af68", bold = true })
                vim.api.nvim_set_hl(0, "NvimTreeModifiedIcon", { fg = "#e0af68" })
              end,
            })
          '';
        };
      };
    };
  };
}
