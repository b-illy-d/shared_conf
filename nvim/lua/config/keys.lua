local map = vim.keymap.set
local tb = require("telescope.builtin")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-- Tree / Files
map("n", "<C-t>", "<cmd>NvimTreeToggle<cr>", { desc = "File Explorer" })
map("n", "<leader>f", tb.find_files, { desc = "files" })

local function live_grep_to_qf(opts)
  opts = opts or {}
  opts.additional_args = vim.list_extend(opts.additional_args or {}, { "--hidden", "--glob", "!**/.git/*" })

  opts.attach_mappings = function(prompt_bufnr, _)
    actions.select_default:replace(function()
      local picker = action_state.get_current_picker(prompt_bufnr)

      -- snapshot all results for quickfix
      local qf_items = {}
      for entry in picker.manager:iter() do
        table.insert(qf_items, {
          filename = entry.path or entry.filename,
          lnum     = entry.lnum or entry.line or 1,
          col      = entry.col or 1,
          text     = entry.text or entry.value,
        })
      end

      -- chosen entry to jump to
      local sel = action_state.get_selected_entry()
      actions.close(prompt_bufnr)

      if sel then
        local file = sel.path or sel.filename
        local lnum = sel.lnum or sel.line or 1
        local col  = (sel.col or 1) - 1
        vim.cmd("edit " .. vim.fn.fnameescape(file))
        pcall(vim.api.nvim_win_set_cursor, 0, { lnum, math.max(col, 0) })
      end

      -- fill quickfix in the background
      vim.fn.setqflist({}, " ", { title = "Telescope: live_grep", items = qf_items })
      vim.cmd("cwindow | wincmd p")
    end)
    return true
  end

  tb.live_grep(opts)
end


-- Find / Replace
map("n", "<leader>g", function()
  live_grep_to_qf({})
end, { desc = "grep" })
map("n", "<leader>G", function()
  live_grep_to_qf({ default_text = vim.fn.expand("<cword>") })
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
-- map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "code action" })

-- Diagnostics
map("n", "<leader>dd", function()
  vim.diagnostic.setqflist({ open = true, severity = vim.diagnostic.severity.ERROR })
end)
map("n", "<leader>dw", function()
  vim.diagnostic.setqflist({ open = true, severity = { min = vim.diagnostic.severity.WARN } })
end)
map("n", "<leader>dm", function()
  vim.cmd("silent make!")
  vim.cmd("copen")
end, { desc = "make and open quickfix" })

map("n", "[d", vim.diagnostic.goto_prev, { desc = "prev diag" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "next diag" })
map("n", "<leader>yd", function()
  local diags = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
  if #diags > 0 then
    vim.fn.setreg("+", diags[1].message)
  end
end, { desc = "yank diagnostic message" })
map("n", "<leader>y%", ":let @+ = expand('%')<cr>", { desc = "yank buffer filename to +" })

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

-- Terminal
map("n", "<leader>t", function()
  if vim.fn.bufexists("term://*") == 1 then
    vim.cmd("buffer term://*")
  else
    vim.cmd("vsplit | terminal zsh -l")
  end
end, { desc = "vertical terminal (reuse)" })
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "exit terminal mode" })

-- Quit
vim.api.nvim_create_user_command("Q", function()
  vim.cmd("qa")
end, { desc = "Quit all" })
