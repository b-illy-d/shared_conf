vim.o.guifont = "JetBrainsMono Nerd Font:h16"

if vim.g.neovide then
  vim.g.neovide_cursor_animation_length = 0.02
  vim.g.neovide_cursor_trail_size = 0
  vim.g.neovide_cursor_antialiasing = false
  vim.g.neovide_input_ime = false
end

local function apply_gui_highlights()
  local hi = vim.api.nvim_set_hl

  -- Diff
  hi(0, "DiffAdd", { fg = "#aaff88", bg = "#003300", bold = false })
  hi(0, "DiffChange", { fg = "NONE", bg = "NONE", bold = false })
  hi(0, "DiffDelete", { fg = "#ffaa88", bg = "#330000", bold = false })
  hi(0, "DiffText", { fg = "#00aaff", bg = "#444444", bold = true })

  -- Tabline
  hi(0, "TabLineSel", { fg = "#00aaff", bg = "#444444", bold = true })
  hi(0, "TabLine", { fg = "#444444", bg = "NONE", bold = false })

  -- Popup menu
  hi(0, "Pmenu", { fg = "#dddddd", bg = "#333333", bold = false })
end

apply_gui_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("gui_rehighlight", { clear = true }),
  callback = apply_gui_highlights,
})


if vim.g.neovide then
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      if vim.wo.diff then
        vim.o.columns = 600
      else
        vim.o.columns = 100
      end
    end,
  })
end
