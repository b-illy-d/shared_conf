vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  rocks = { enabled = false },
  ui = { border = "rounded" },
  change_detection = { notify = false },
  git = { submodules = false, },
})

-- set theme first
require("config.theme")
-- other configs might override
require("config.autocmds")
require("config.format")
require("config.keys")
require("config.opts")
require("config.whitespace")
require("config.gui")
require("config.diagnostic")
