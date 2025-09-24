return {
  "sudo-tee/opencode.nvim",
  config = function()
    require("opencode").setup({
      -- keymap = {
      --   toggle = "<leader>oa",                        -- Open opencode. Close if opened
      --   open_input = "<leader>oi",                    -- Opens and focuses on input window on insert mode
      --   open_input_new_session = "<leader>oI",        -- Opens and focuses on input window on insert mode. Creates a new session
      --   open_output = "<leader>oo",                   -- Opens and focuses on output window
      --   toggle_focus = "<leader>ot",                  -- Toggle focus between opencode and last window
      --   close = "<leader>oq",                         -- Close UI windows
      --   toggle_fullscreen = "<leader>of",             -- Toggle between normal and fullscreen mode
      --   select_session = "<leader>os",                -- Select and load a opencode session
      --   configure_provider = "<leader>op",            -- Quick provider and model switch from predefined list
      --   diff_open = "<leader>od",                     -- Opens a diff tab of a modified file since the last opencode prompt
      --   diff_next = "<leader>o]",                     -- Navigate to next file diff
      --   diff_prev = "<leader>o[",                     -- Navigate to previous file diff
      --   diff_close = "<leader>oc",                    -- Close diff view tab and return to normal editing
      --   diff_revert_all_last_prompt = "<leader>ora",  -- Revert all file changes since the last opencode prompt
      --   diff_revert_this_last_prompt = "<leader>ort", -- Revert current file changes since the last opencode prompt
      --   diff_revert_all = "<leader>orA",              -- Revert all file changes since the last opencode session
      --   diff_revert_this = "<leader>orT",
      -- },
      ui = {
        position = "right",
        floating = false,                                                          -- Use floating windows for input and output
        window_width = 0.40,                                                       -- Width as percentage of editor width
        input_height = 0.15,                                                       -- Input height as percentage of window height
        fullscreen = false,                                                        -- Start in fullscreen mode (default: false)
        floating_height = 0.8,                                                     -- Height as percentage of editor height for "center" layout
        display_model = true,                                                      -- Display model name on top winbar
        window_highlight = "Normal:OpencodeBackground,FloatBorder:OpencodeBorder", -- Highlight group for the opencode window
        output = {
          tools = {
            show_output = true, -- Show tools output [diffs, cmd output, etc.] (default: true)
          },
        },
      },
      -- provider = {
      --   default_provider = "google",
      --   default_model = "gemini-2.5-flash",
      -- },

      -- Qwen3 Coder 480B A35B
      provider = {
        default_provider = "openrouter",
        default_model    = "qwen/qwen3-coder:free",
        openrouter       = {
          api_key = os.getenv("OPENROUTER_API_KEY"),
          base_url = "https://openrouter.ai/api/v1",
          models = {
            ["qwen/qwen3-coder:free"] = { options = { maxTokens = 2048 } }
          }
        }
      }

      -- -- Kimi K2 0711 (Alternative if Qwen3 unavailable)
      -- provider = {
      --   default_provider = "openrouter",
      --   default_model = "moonshotai/kimi-k2-0711:free",
      -- }
    })
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        anti_conceal = { enabled = false },
        file_types = { "markdown", "opencode_output" },
      },
      ft = { "markdown", "Avante", "copilot-chat", "opencode_output" },
    },
  },
}
