local M = {}

function M.setup()
  vim.opt_local.makeprg = "npx tsc --noEmit"
  vim.opt_local.errorformat = table.concat({
    "%E%f(%l,%c): error TS%n: %m",
    "%W%f(%l,%c): warning TS%n: %m",
    "%-G%.%#",
  }, ",")
end

return M
