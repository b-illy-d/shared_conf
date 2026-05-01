return {
  {
    "carderne/pi-nvim",
    config = function()
      require("pi-nvim").setup()
      vim.keymap.set("n", "<leader>pp", ":PiSendFile<CR>")
      vim.keymap.set("v", "<leader>pp", ":PiSendSelection<CR>")
      vim.keymap.set({ "n", "v" }, "<leader>pf", ":PiSendFile<CR>")
      vim.keymap.set({ "n", "v" }, "<leader>pb", ":PiSendBuffer<CR>")
      vim.keymap.set({ "n", "v" }, "<leader>pi", ":PiPing<CR>")
    end
  }
}
