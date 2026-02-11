-- Hi mom

local o = vim.opt

-- haters gonna hate
o.hidden = true

-- display
o.number = true
o.relativenumber = true
o.scrolloff = 10
o.autowrite = true
o.hlsearch = true
o.history = 100
o.signcolumn = "yes"
o.sidescrolloff = 6

-- indent
o.expandtab = true
o.smartindent = true
o.shiftwidth = 2
o.softtabstop = 2
o.tabstop = 2

-- folding
o.foldenable = true
o.foldlevel = 99
o.foldlevelstart = 99
o.foldcolumn = "3"
o.foldmethod = "expr"

o.splitright = true
o.splitbelow = true
o.termguicolors = true
o.mouse = "a"
o.clipboard = ""
o.ignorecase = true
o.smartcase = true
o.updatetime = 200
o.timeoutlen = 400
o.completeopt = "menu,menuone,noselect"
