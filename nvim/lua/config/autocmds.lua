local aug = vim.api.nvim_create_augroup
local ac  = vim.api.nvim_create_autocmd
local grp = aug("mine", { clear = true })

aug("mine", { clear = true })

ac("BufWritePre", {
  group = "mine",
  callback = function(args)
    local ok, conform = pcall(require, "conform")
    if ok then conform.format({ bufnr = args.buf, lsp_fallback = true }) end
  end
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

