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
local function combined_float()
  local opts = {
    border = "rounded",
    focusable = false,
    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
  }
  local util = vim.lsp.util
  local params = util.make_position_params()
  local lines = {}

  local function section(title, body)
    if body and #body > 0 then
      if #lines > 0 then table.insert(lines, "") end
      table.insert(lines, ("**%s**"):format(title))
      for _, l in ipairs(body) do table.insert(lines, l) end
    end
  end

  -- 1) Diagnostics at cursor
  do
    local cur = vim.api.nvim_win_get_cursor(0)
    local diags = vim.diagnostic.get(0, { lnum = cur[1] - 1 })
    local dl = {}
    for _, d in ipairs(diags) do
      local sev = vim.diagnostic.severity[d.severity] or "INFO"
      local src = d.source and (" (%s)"):format(d.source) or ""
      local msg = (d.message or ""):gsub("\r", " "):gsub("\n", " ")
      table.insert(dl, ("- *%s*%s: %s"):format(sev, src, msg))
    end
    section("Diagnostics", dl)
  end

  -- 2) Hover docs
  do
    local results = vim.lsp.buf_request_sync(0, "textDocument/hover", params, 300)
    local hl = {}
    if results then
      for _, res in pairs(results) do
        if res.result and res.result.contents then
          local md = util.convert_input_to_markdown_lines(res.result.contents)
          md = util.trim_empty_lines(md)
          for _, l in ipairs(md) do table.insert(hl, l) end
          break
        end
      end
    end
    section("", hl)
  end

  -- 3) Signature help (call-site)
  do
    local results = vim.lsp.buf_request_sync(0, "textDocument/signatureHelp", params, 300)
    local sl = {}
    if results then
      for _, res in pairs(results) do
        local sighelp = res.result
        if sighelp and sighelp.signatures and sighelp.signatures[1] then
          local sig = sighelp.signatures[sighelp.activeSignature or 1] or
              sighelp.signatures[1]
          local label = sig.label or ""
          table.insert(sl, ("`%s`"):format(label))
          local ap = (sighelp.activeParameter or 0) + 1
          if sig.parameters and sig.parameters[ap] then
            local p = sig.parameters[ap]
            local plabel = type(p.label) == "table" and
                label:sub(p.label[1] + 1, p.label[2]) or p.label
            if plabel and #tostring(plabel) > 0 then
              table.insert(sl, ("Active parameter: **%s**"):format(plabel))
            end
          end
          if sig.documentation then
            local md = util.convert_input_to_markdown_lines(sig.documentation)
            md = util.trim_empty_lines(md)
            for _, l in ipairs(md) do table.insert(sl, l) end
          end
          break
        end
      end
    end
    section("", sl)
  end

  if #lines == 0 then
    lines = { "_No diagnostics/hover/signature available here._" }
  end

  util.open_floating_preview(lines, "markdown", opts)
end

map("n", "K", combined_float, { desc = "diagnostics + hover + signature" })
map("n", "gr", vim.lsp.buf.references, { desc = 'goto references' })
map("n", "gd", vim.lsp.buf.definition, { desc = "goto def" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "impl" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "rename" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "code action" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "prev diag" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "next diag" })
map("n", "<leader>yd", function()
  local diags = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
  if #diags > 0 then
    vim.fn.setreg("+", diags[1].message)
  end
end, { desc = "yank diagnostic message" })
map("n", "<leader>yn", function()
  local node = vim.treesitter.get_node()
  if node then
    local text = vim.treesitter.get_node_text(node, 0)
    vim.fn.setreg("+", text)
  end
end, { desc = "yank treesitter node text" })


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

-- Quit
vim.api.nvim_create_user_command("Q", function()
  vim.cmd("qa")
end, { desc = "Quit all" })
