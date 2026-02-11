return {
  dir = "/Users/billy/lifemode.nvim",
  config = function()
    require('lifemode').setup({
      vault_path = "~/test_vault",
      sidebar = { width_percent = 30 },
      keymaps = {
        new_node = "<leader>nc",
        narrow = "<leader>nn",
        widen = "<leader>nw",
        jump_context = "<leader>nj",
        toggle_sidebar = "<leader>ns",
        find_node = "<leader>ff",
      }
    })
  end
}
