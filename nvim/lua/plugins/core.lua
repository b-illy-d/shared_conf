return {
  ---------------------------------------------------------------------------
  -- Core editing enhancements
  ---------------------------------------------------------------------------
  { "tpope/vim-unimpaired" },
  { "tpope/vim-fugitive" },
  { "tpope/vim-repeat" },
  { "tpope/vim-speeddating" },
  { "svermeulen/vim-subversive" },
  { "junegunn/vim-easy-align" },
  { "mg979/vim-visual-multi",   branch = "master" },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = true,
  },

  ---------------------------------------------------------------------------
  -- Commenting, motions, textobjects
  ---------------------------------------------------------------------------
  {
    "numToStr/Comment.nvim",
    opts = {
      toggler = {
        line = 'gcc',
        block = 'gbc',
      },
      opleader = {
        ---Line-comment keymap
        line = 'gc',
        ---Block-comment keymap
        block = 'gb',
      },
      mappings = {
        ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        basic = true,
      }
    },
    config = function()
      require("Comment").setup()
    end
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    config = function()
      require("ufo").setup({
        provider_selector = function(_, _, _)
          return { "treesitter", "indent" }
        end,
      })
    end,
  },

  ---------------------------------------------------------------------------
  -- UI and statusline
  ---------------------------------------------------------------------------
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 3 } },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { { function() return os.date("%H:%M") end } },
          lualine_z = { "location" },
        },
      })
    end
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("bufferline").setup() end
  },
  { "folke/which-key.nvim",          opts = {} },

  ---------------------------------------------------------------------------
  -- File management / search
  ---------------------------------------------------------------------------
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = {
          side = "left",
          width = 35,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = false,
        },
      })
    end,
  },

  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    cond = vim.fn.executable("make") == 1,
    config = function() require("telescope").load_extension("fzf") end
  },

  ---------------------------------------------------------------------------
  -- Git integration
  ---------------------------------------------------------------------------
  { "lewis6991/gitsigns.nvim",        opts = {} },
  {
    "samoshkin/vim-mergetool",
    lazy = false,
    init = function()
      vim.g.mergetool_layout = "mr"
      vim.g.mergetool_prefer_revision = "local"
    end,
    keys = {
      { "<leader>mt", "<Plug>(MergetoolToggle)", desc = "Toggle mergetool" },
      { "<C-Left>", function() return vim.o.diff and "<Plug>(MergetoolDiffExchangeLeft)" or "<C-Left>" end, expr = true },
      { "<C-Right>", function() return vim.o.diff and "<Plug>(MergetoolDiffExchangeRight)" or "<C-Right>" end, expr = true },
      { "<C-Down>", function() return vim.o.diff and "<Plug>(MergetoolDiffExchangeDown)" or "<C-Down>" end, expr = true },
      { "<C-Up>", function() return vim.o.diff and "<Plug>(MergetoolDiffExchangeUp)" or "<C-Up>" end, expr = true },
    },
  },

  ---------------------------------------------------------------------------
  -- Syntax highlighting and parsing
  ---------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
      "Hiphish/rainbow-delimiters.nvim",
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    opts = {
      ensure_installed = {
        "bash",
        "css",
        "go",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "rust",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>",
          node_incremental = "<CR>",
          scope_incremental = "<S-CR>",
          node_decremental = "<BS>",
        },
      },

      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            ["ia"] = "@parameter.inner",
            ["aa"] = "@parameter.outer",
            ["is"] = "@statement.inner",
            ["as"] = "@statement.outer",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>a"] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>A"] = "@parameter.inner",
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      -- autotag
      require("nvim-ts-autotag").setup()

      -- rainbow-delimiters
      local rd = require("rainbow-delimiters")
      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rd.strategy["global"],
          vim  = rd.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua  = "rainbow-blocks",
        },
        priority = { [""] = 110, lua = 110 },
      }
      -- jsx-aware comments
      require("ts_context_commentstring").setup({})
      vim.g.skip_ts_context_commentstring_module = true
    end,
  },
  { "Hiphish/rainbow-delimiters.nvim" },
  { "NvChad/nvim-colorizer.lua",      opts = {} },

  ---------------------------------------------------------------------------
  -- Undo / history
  ---------------------------------------------------------------------------
  { "mbbill/undotree" },

  ---------------------------------------------------------------------------
  -- Formatters / linters
  ---------------------------------------------------------------------------
  { "stevearc/conform.nvim" },

  ---------------------------------------------------------------------------
  -- Debugging
  ---------------------------------------------------------------------------
  { "mfussenegger/nvim-dap" },
  { "rcarriga/nvim-dap-ui",           dependencies = { "mfussenegger/nvim-dap" } },
}
