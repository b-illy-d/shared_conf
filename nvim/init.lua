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
-- global configs
require("config.autocmds")
require("config.diagnostic")
require("config.format")
require("config.git")
require("config.gui")
require("config.js")
require("config.markdown")
require("config.keys")
require("config.opts")
require("config.terminal")
require("config.whitespace")
-- by language
require("config.js")

-- local specific
vim.g.python3_host_prog = "/Users/billy/.local/share/uv/python/cpython-3.12.10-macos-aarch64-none/bin/python3.12"
