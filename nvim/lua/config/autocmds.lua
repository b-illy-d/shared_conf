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

-- Autosave
vim.api.nvim_create_autocmd({ "BufEnter", "BufLeave" }, {
  group = grp,
  callback = function(args)
    local bufnr = args.buf

    vim.defer_fn(function()
      -- buffer may have been wiped/reused since the event fired
      if not vim.api.nvim_buf_is_valid(bufnr) then return end
      if not vim.api.nvim_buf_is_loaded(bufnr) then return end

      -- safest way to touch buffer options
      local ok, b = pcall(function() return vim.bo[bufnr] end)
      if not ok or not b then return end

      -- skip junk buffers
      if b.buftype ~= "" then return end      -- nofile, prompt, help, etc.
      if b.buflisted == false then return end -- many plugin buffers
      if b.readonly or not b.modifiable then return end

      local name = vim.api.nvim_buf_get_name(bufnr)
      if name == "" then return end
      if not b.modified then return end

      -- only write that buffer, don't rely on current window context
      vim.api.nvim_buf_call(bufnr, function()
        vim.cmd("silent! update")
      end)
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
