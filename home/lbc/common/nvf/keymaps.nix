let
  n = key: action: {
    inherit key action;
    mode = "n";
    silent = true;
  };
  t = key: action: {
    inherit key action;
    mode = "t";
    silent = true;
  };
in
{
  keymaps = [
    # ── File explorer ──────────────────────────────────────────────
    (n "<leader>e" "<cmd>NvimTreeToggle<CR>")

    # ── Telescope ──────────────────────────────────────────────────
    (n "<leader>ff" "<cmd>Telescope find_files<CR>")
    (n "<leader>fg" "<cmd>Telescope live_grep<CR>")
    (n "<leader>fb" "<cmd>Telescope buffers<CR>")

    # ── Terminal ───────────────────────────────────────────────────
    (n "<leader>tt" "<cmd>ToggleTerm direction=horizontal<CR>")
    (n "<leader>tg" "<cmd>LazyGit<CR>")

    # ── Tabs ───────────────────────────────────────────────────────
    (n "<leader>tn" "<cmd>tabnew<CR>")
    (n "<leader>tc" "<cmd>tabclose<CR>")
    (n "<leader>t]" "<cmd>tabnext<CR>")
    (n "<leader>t[" "<cmd>tabprev<CR>")

    # ── Buffers ────────────────────────────────────────────────────
    (n "<Tab>" "<cmd>bnext<CR>")
    (n "<S-Tab>" "<cmd>bprev<CR>")

    # ── LSP ────────────────────────────────────────────────────────
    (n "<leader>ca" "<cmd>lua vim.lsp.buf.code_action()<CR>")
    (n "<leader>rn" "<cmd>lua vim.lsp.buf.rename()<CR>")
    (n "<leader>cf" "<cmd>lua vim.lsp.buf.format({ async = true })<CR>")
    (n "gd" "<cmd>lua vim.lsp.buf.definition()<CR>")
    (n "K" "<cmd>lua vim.lsp.buf.hover()<CR>")

    # ── Save / quit ────────────────────────────────────────────────
    (n "<leader>ww" "<cmd>w<CR>")
    (n "<leader>wq" "<cmd>wqa<CR>")
    (n "<leader>qq" "<cmd>qa!<CR>")

    # ── Window focus – normal mode ─────────────────────────────────
    (n "<C-h>" "<C-w>h")
    (n "<C-l>" "<C-w>l")
    (n "<C-j>" "<C-w>j")
    (n "<C-k>" "<C-w>k")
    (n "<C-p>" "<C-w>p")

    # ── Window focus – terminal mode ───────────────────────────────
    (t "<C-h>" "<C-\\><C-n><C-w>h")
    (t "<C-l>" "<C-\\><C-n><C-w>l")
    (t "<C-j>" "<C-\\><C-n><C-w>j")
    (t "<C-k>" "<C-\\><C-n><C-w>k")
    (t "<C-p>" "<C-\\><C-n><C-w>p")

    # ── Split management ───────────────────────────────────────────
    (n "<leader>sv" "<cmd>vsplit<CR>")
    (n "<leader>sh" "<cmd>split<CR>")
    (n "<leader>sc" "<cmd>close<CR>")

    # ── Resize splits ──────────────────────────────────────────────
    (n "<C-Left>" "<cmd>vertical resize -2<CR>")
    (n "<C-Right>" "<cmd>vertical resize +2<CR>")
    (n "<C-Up>" "<cmd>resize +2<CR>")
    (n "<C-Down>" "<cmd>resize -2<CR>")

    # ── Misc ───────────────────────────────────────────────────────
    (n "<CR>" "i<CR><Esc>") # insert newline without entering insert mode
  ];
}
