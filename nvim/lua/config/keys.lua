local map = vim.keymap.set
local tb = require("telescope.builtin")

-- Tree / Files
map("n", "<C-t>", "<cmd>NvimTreeToggle<cr>", { desc = "File Explorer" })
map("n", "<leader>f", tb.find_files, { desc = "files" })

-- Find / Replace
map("n", "<leader>g", function() tb.live_grep({ additional_args = { "--hidden", "--glob", "!**/.git/*" } }) end,
  { desc = "grep" })
map("n", "<leader>G", function()
  tb.live_grep({
    default_text = vim.fn.expand("<cword>"),
    additional_args = { "--hidden", "--glob", "!**/.git/*" },
  })
end, { desc = "live grep for cword" })
map("n", "<leader>b", tb.buffers, { desc = "buffers" })
map("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "undo tree" })
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>//g<Left><Left>]], { desc = "substitute cword" })

-- Buf and Quickfix
map("n", "<C-j>", ":bprev<CR>", { silent = true, desc = "prev buffer" })
map("n", "<C-k>", ":bnext<CR>", { silent = true, desc = "next buffer" })
map("n", "]q", ":cnext<CR>", { silent = true, desc = "next quickfix" })
map("n", "[q", ":cprev<CR>", { silent = true, desc = "prev quickfix" })
map("n", "]Q", ":clast<CR>", { silent = true, desc = "last quickfix" })
map("n", "[Q", ":cfirst<CR>", { silent = true, desc = "first quickfix" })

-- LSP
map("n", "gr", vim.lsp.buf.references, { desc = 'goto references' })
map("n", "gd", vim.lsp.buf.definition, { desc = "goto def" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "impl" })
map("n", "K", function()
  local opts = {
    scope = "cursor",
    border = "rounded",
    source = "always",
    focusable = false,
    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
  }
  local cur = vim.api.nvim_win_get_cursor(0)
  local diags = vim.diagnostic.get(0, { lnum = cur[1] - 1 })
  if #diags > 0 then
    vim.diagnostic.open_float(0, opts)
  else
    vim.lsp.buf.hover()
  end
end, { desc = "diagnostic at cursor (fallback: hover)" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "rename" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "code action" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "prev diag" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "next diag" })

local function toggle_relnum()
  vim.wo.relativenumber = not vim.wo.relativenumber
end
map("n", "<C-l>", toggle_relnum, { desc = "toggle relativenumber" })

-- Diff navigation
vim.keymap.set("n", "<Tab>", function()
  return vim.wo.diff and "]c" or "<Tab>"
end, { expr = true })

vim.keymap.set("n", "<S-Tab>", function()
  return vim.wo.diff and "[c" or "<S-Tab>"
end, { expr = true })

-- Comment.nvim equivalents for your Commentary mappings
map("n", "<leader>c", function() require("Comment.api").toggle.linewise.current() end, { desc = "comment line" })
map("v", "<leader>c", function() require("Comment.api").toggle.linewise(vim.fn.visualmode()) end,
  { desc = "comment selection" })

-- Terminal
map("n", "<leader>t", function()
  if vim.fn.bufexists("term://*") == 1 then
    vim.cmd("buffer term://*")
  else
    vim.cmd("vsplit | terminal zsh -f")
  end
end, { desc = "vertical terminal (reuse)" })
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "exit terminal mode" })
