local grp = vim.api.nvim_create_augroup("badws", { clear = true })

-- ensure each window has a trailing-whitespace match
local function ensure_match()
  if vim.bo.buftype == "terminal" then return end -- skip terminals
  if vim.w.badws_id then pcall(vim.fn.matchdelete, vim.w.badws_id) end
  vim.w.badws_id = vim.fn.matchadd("BadWhitespace", [[\s\+$]])
end

-- show in normal, hide in insert/replace/etc
local function apply_mode()
  if vim.bo.buftype == "terminal" then return end -- skip terminals
  local m = vim.api.nvim_get_mode().mode
  if m:match("^i") or m:match("^R") or m:match("^s") then
    vim.api.nvim_set_hl(0, "BadWhitespace", { bg = "NONE" })
  else
    vim.api.nvim_set_hl(0, "BadWhitespace", { bg = "#ff7777" })
  end
end

-- first-time setup
vim.api.nvim_set_hl(0, "BadWhitespace", { bg = "#ff7777" })
ensure_match()
apply_mode()

-- keep the match present per-window
vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
  group = grp,
  callback = function()
    ensure_match()
    apply_mode()
  end,
})

-- swap style on mode change
vim.api.nvim_create_autocmd("ModeChanged", {
  group = grp,
  callback = apply_mode,
})

-- if text changes, keep the match alive
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "TextChangedI" }, {
  group = grp,
  callback = ensure_match,
})
