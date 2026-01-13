return {
  {
    'rhart92/codex.nvim',
    config = function()
      require('codex').setup({
        focus_after_send = true,
        split = 'vertical',
        size = 0.4,
      })
      vim.keymap.set("n", "<leader>Ca", function() require("codex").toggle() end, { desc = "toggle codex" })
      vim.keymap.set("v", "<leader>Ca", function() require("codex").actions.send_selection() end,
        { desc = "Codex: Send selection" })
    end
  },
}
