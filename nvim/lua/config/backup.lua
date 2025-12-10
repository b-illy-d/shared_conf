-- Persistent undo
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo//"
vim.fn.mkdir(vim.fn.stdpath("state") .. "/undo", "p")

-- Swap
vim.opt.swapfile = true
vim.opt.directory = vim.fn.stdpath("state") .. "/swap//"
vim.fn.mkdir(vim.fn.stdpath("state") .. "/swap", "p")

-- Backups
vim.opt.backup = true
vim.opt.writebackup = true
vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup//"
vim.fn.mkdir(vim.fn.stdpath("state") .. "/backup", "p")

-- Cleanup old undo, swap, and backup files (older than 7 days)
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local paths = {
      vim.opt.undodir:get(),
      vim.opt.directory:get(),
      vim.opt.backupdir:get(),
    }
    local seven_days_ago = os.time() - (7 * 24 * 60 * 60)
    for _, path in ipairs(paths) do
      local handle = io.popen('find "' .. path .. '" -type f -not -newermt "@' .. seven_days_ago .. '" -delete')
      if handle then handle:close() end
    end
  end,
})
