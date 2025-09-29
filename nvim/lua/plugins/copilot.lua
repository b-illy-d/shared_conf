return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      panel = { enabled = false },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = "<Tab>",
          next = "<A-]>",
          prev = "<A-[>",
          dismiss = "C-]",
        },
      },
    }
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function() require("copilot_cmp").setup() end
  },
  {
    'johnseth97/codex.nvim',
    lazy = true,
    cmd = { 'Codex', 'CodexToggle' }, -- Optional: Load only on command execution
    keys = {
      {
        '<leader>cc', -- Change this to your preferred keybinding
        function() require('codex').toggle() end,
        desc = 'Toggle Codex popup',
      },
    },
    opts = {
      keymaps     = {
        toggle = nil,          -- Keybind to toggle Codex window (Disabled by default, watch out for conflicts)
        quit = '<C-q>',        -- Keybind to close the Codex window (default: Ctrl + q)
      },                       -- Disable internal default keymap (<leader>cc -> :CodexToggle)
      border      = 'rounded', -- Options: 'single', 'double', or 'rounded'
      width       = 0.8,       -- Width of the floating window (0.0 to 1.0)
      height      = 0.8,       -- Height of the floating window (0.0 to 1.0)
      model       = nil,       -- Optional: pass a string to use a specific model (e.g., 'o3-mini')
      autoinstall = true,      -- Automatically install the Codex CLI if not found
    },
  },
  {
    'greggh/claude-code.nvim',
    requires = {
      'nvim-lua/plenary.nvim', -- Required for git operations
    },
    config = function()
      require('claude-code').setup({
        window = {
          split_ratio = 0.3,      -- Percentage of screen for the terminal window (height for horizontal, width for vertical splits)
          position = "float",     -- Position of the window: "botright", "topleft", "vertical", "float", etc.
          enter_insert = true,    -- Whether to enter insert mode when opening Claude Code
          hide_numbers = true,    -- Hide line numbers in the terminal window
          hide_signcolumn = true, -- Hide the sign column in the terminal window

          -- Floating window configuration (only applies when position = "float")
          float = {
            width = "80%",       -- Width: number of columns or percentage string
            height = "80%",      -- Height: number of rows or percentage string
            row = "center",      -- Row position: number, "center", or percentage string
            col = "center",      -- Column position: number, "center", or percentage string
            relative = "editor", -- Relative to: "editor" or "cursor"
            border = "rounded",  -- Border style: "none", "single", "double", "rounded", "solid", "shadow"
          },
        },
        -- File refresh settings
        refresh = {
          enable = true,             -- Enable file change detection
          updatetime = 100,          -- updatetime when Claude Code is active (milliseconds)
          timer_interval = 1000,     -- How often to check for file changes (milliseconds)
          show_notifications = true, -- Show notification when files are reloaded
        },
        -- Git project settings
        git = {
          use_git_root = true, -- Set CWD to git root when opening Claude Code (if in git project)
        },
        -- Shell-specific settings
        shell = {
          separator = '&&',    -- Command separator used in shell commands
          pushd_cmd = 'pushd', -- Command to push directory onto stack (e.g., 'pushd' for bash/zsh, 'enter' for nushell)
          popd_cmd = 'popd',   -- Command to pop directory from stack (e.g., 'popd' for bash/zsh, 'exit' for nushell)
        },
        -- Command settings
        command = "claude", -- Command used to launch Claude Code
        -- Command variants
        command_variants = {
          -- Conversation management
          continue = "--continue", -- Resume the most recent conversation
          resume = "--resume",     -- Display an interactive conversation picker

          -- Output options
          verbose = "--verbose", -- Enable verbose logging with full turn-by-turn output
        },
        -- Keymaps
        keymaps = {
          toggle = {
            normal = "<C-,>",          -- Normal mode keymap for toggling Claude Code, false to disable
            terminal = "<C-,>",        -- Terminal mode keymap for toggling Claude Code, false to disable
            variants = {
              continue = "<leader>cC", -- Normal mode keymap for Claude Code with continue flag
              verbose = "<leader>cV",  -- Normal mode keymap for Claude Code with verbose flag
            },
          },
          window_navigation = true, -- Enable window navigation keymaps (<C-h/j/k/l>)
          scrolling = true,         -- Enable scrolling keymaps (<C-f/b>) for page up/down
        }
      })
    end
  },
}
