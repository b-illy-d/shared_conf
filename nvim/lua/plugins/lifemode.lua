return {
  {
    'b-illy-d/lifemode.nvim',
    config = function()
      require('lifemode').setup({
        vault_root = vim.fn.expand("~/lm"), -- REQUIRED: Your notes directory
        leader = '<Space>',                 -- Optional: LifeMode leader key (default)
        max_depth = 10,                     -- Optional: Max expansion depth (default)
        bible_version = 'RSVCE',            -- Optional: Bible version (default)
      })
    end,
  }
}
