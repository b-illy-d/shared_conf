-- If it's a TS/TSX file, then set the make program
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "typescriptreact" },
  callback = function()
    vim.bo.makeprg = "npx tsc --noEmit --pretty false"
    vim.bo.errorformat =
        "%E%f(%l\\,%c): error %m," ..
        "%W%f(%l\\,%c): warning %m," ..
        "%-G%.%#" -- ignore the rest
  end,
})
