{
  luaConfigRC = {
    # NvimTree: use h/l to collapse/expand nodes
    nvimtree-keys = ''
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "NvimTree",
        callback = function(args)
          local api = require("nvim-tree.api")
          vim.keymap.set("n", "l", api.node.open.edit,             { buffer = args.buf, silent = true })
          vim.keymap.set("n", "h", api.node.navigate.parent_close, { buffer = args.buf, silent = true })
        end,
      })
    '';

    # Richer LSP-based syntax coloring
    go-highlight = ''
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client then
            client.server_capabilities.semanticTokensProvider =
              client.server_capabilities.semanticTokensProvider
          end
        end,
      })
    '';

    # Consistent indentation for main filetypes
    indentation = ''
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "go", "nix", "python" },
        callback = function()
          vim.opt_local.indentexpr     = ""
          vim.opt_local.autoindent     = true
          vim.opt_local.preserveindent = true
        end,
      })
    '';

    # Always show the tabline
    tabline = ''
      vim.opt.showtabline = 2
    '';

    # Escape terminal mode with <Esc>
    terminal-keymap = ''
      vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { silent = true })
    '';

    # Which-key group labels
    which-key = ''
      require("which-key").add({
        { "<leader>f", group = "find/file"     },
        { "<leader>t", group = "terminal/tabs" },
        { "<leader>w", group = "save"          },
        { "<leader>q", group = "quit"          },
        { "<leader>c", group = "code/format"   },
        { "<leader>r", group = "rename"        },
        { "<leader>s", group = "splits"        },
        { "g",         group = "goto"          },
      })
    '';

    # Bufferline: show shortened relative paths (e.g. s/c/file.go)
    bufferline-path = ''
      vim.defer_fn(function()
        require("bufferline").setup(vim.tbl_deep_extend("force", {}, {
          options = {
            name_formatter = function(buf)
              local cwd   = vim.fn.getcwd()
              local rel   = buf.path:gsub("^" .. vim.pesc(cwd) .. "/", "")
              local parts = vim.split(rel, "/")
              local out   = {}
              for i, part in ipairs(parts) do
                table.insert(out, i < #parts and part:sub(1, 1) or part)
              end
              return table.concat(out, "/")
            end,
          },
        }))
      end, 100)
    '';

    # Highlight modified files in the tree with a warm amber colour
    nvimtree-highlight = ''
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
          vim.api.nvim_set_hl(0, "NvimTreeModifiedFile", { fg = "#e0af68", bold = true })
          vim.api.nvim_set_hl(0, "NvimTreeModifiedIcon", { fg = "#e0af68" })
        end,
      })
    '';

    # Create missing parent directories when saving
    auto-mkdir = ''
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("AutoMkdir", { clear = true }),
        callback = function(ev)
          -- skip special buffers and URLs (scp://, fugitive://, etc.)
          if vim.bo[ev.buf].buftype ~= "" or ev.match:match("^%w+://") then
            return
          end
          vim.fn.mkdir(vim.fn.fnamemodify(ev.match, ":p:h"), "p")
        end,
      })
    '';
  };
}
