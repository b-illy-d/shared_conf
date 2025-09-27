require("conform").setup({
  formatters_by_ft = {
    javascript = { "prettierd", "prettier" },
    typescript = { "prettierd", "prettier" },
    json = { "jq" },
    python = { "ruff_format", "black" },
    go = { "gofumpt", "gofmt" },
    rust = { "rustfmt" },
    sh = { "shfmt" },
  },
})
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("format_on_save", { clear = true }),
  callback = function(args) require("conform").format({ bufnr = args.buf, lsp_fallback = true }) end,
})
