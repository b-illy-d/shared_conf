local aug = vim.api.nvim_create_augroup
local ac  = vim.api.nvim_create_autocmd
local grp = aug("mine", { clear = true })

-- Format on save using conform.nvim
ac("BufWritePre", {
  group = grp,
  callback = function(args)
    local ok, conform = pcall(require, "conform")
    if not ok then return end
    conform.format({ bufnr = args.buf, lsp_fallback = true })
  end,
})

-- Autosave like crazy
vim.api.nvim_create_autocmd({ "InsertLeave", "FocusLost", "BufLeave" }, {
  group = grp,
  callback = function(args)
    if not vim.api.nvim_buf_is_valid(args.buf) then return end
    if not vim.api.nvim_buf_is_loaded(args.buf) then return end
    vim.defer_fn(function()
      local b = vim.bo[args.buf]
      if b.buftype ~= "" then return end
      if b.readonly or not b.modifiable then return end
      if vim.api.nvim_buf_get_name(args.buf) == "" then return end
      if not b.modified then return end
      vim.cmd("update")
    end, 20)
  end,
})


-- relative number smart toggle
ac({ "BufEnter", "InsertLeave", "FocusGained" }, {
  group = grp,
  callback = function() if vim.wo.number then vim.wo.relativenumber = true end end,
})
ac({ "BufLeave", "InsertEnter", "FocusLost" }, {
  group = grp,
  callback = function() vim.wo.relativenumber = false end,
})
----

-- diff-specific tweaks
ac("OptionSet", {
  pattern = "diff",
  group = grp,
  callback = function()
    if vim.wo.diff then
      vim.opt.diffopt:append("iwhite")
      vim.wo.cursorline = true
    end
  end,
})

-- highlight on yank
ac("TextYankPost", {
  group = grp,
  callback = function() vim.highlight.on_yank({ higroup = "Search", timeout = 500 }) end,
})
