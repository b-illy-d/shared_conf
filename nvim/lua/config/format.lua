require("conform").setup({
  formatters_by_ft = {
    python = { "ruff_fix", "ruff_organize_imports", "ruff_format" }, -- no black
    javascript = { "prettierd", "prettier" },
    typescript = { "prettierd", "prettier" },
    xml = { "prettierd", "prettier" },
    json = { "jq" },
    go = { "gofumpt", "gofmt" },
    rust = { "rustfmt" },
    sh = { "shfmt" },
  },
  format_on_save = {
    timeout_ms = 1000,
    lsp_format = "fallback",
  },
})
