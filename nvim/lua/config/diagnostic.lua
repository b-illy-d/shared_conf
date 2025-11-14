-- Calmer diagnostics tuned for Kanagawa
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#E46876", italic = true })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#E6C384", italic = true })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#7FB4CA", italic = true })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#98BB6C", italic = true })

-- use a subtle prefix
vim.diagnostic.config({
  virtual_text = {
    prefix = "", -- small Nerd Font diamond
    spacing = 2,
  },
  float = {
    border = "shadow", -- "single", "double", "rounded", "solid", "shadow"
    focusable = true,
    style = "minimal",
    source = "always", -- show source in popup
    header = "",
    prefix = "",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
})
