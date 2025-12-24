-- This file contains the configuration for the which-key.nvim plugin in Neovim.

return {
  -- Plugin: which-key.nvim
  -- URL: https://github.com/folke/which-key.nvim
  -- Description: A Neovim plugin that displays a popup with possible keybindings of the command you started typing.
  "folke/which-key.nvim",

  event = "VeryLazy", -- Load this plugin on the 'VeryLazy' event

  init = function()
    -- Set the timeout for key sequences
    vim.o.timeout = true
    vim.o.timeoutlen = 300 -- Set the timeout length to 300 milliseconds
  end,

  opts = {
    preset = "helix", -- For newer versions
  },

  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    -- Define groups that should be available immediately
    wk.add({
      {
        "<leader>?",
        function()
          wk.show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
      { "<leader>O", group = "Obsidian" },
    })
  end,
}
