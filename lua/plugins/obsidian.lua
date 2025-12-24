return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = false,
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "DaniloNotes",                                          -- Name of the workspace
        path = os.getenv("OBSIDIAN_PATH") or "~/Developer/work/notes", -- Path to the notes directory
      },
    },
    completion = {
      blink = true,
    },
    picker = {
      -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', 'mini.pick' or 'snacks.pick'.
      name = "snacks.pick",
    },

    -- Settings for templates
    templates = {
      subdir = "templates",        -- Subdirectory for templates
      date_format = "%Y-%m-%d-%a", -- Date format for templates
      gtime_format = "%H:%M",      -- Time format for templates
      tags = "",                   -- Default tags for templates
    },
  },

  -- Set up keymaps using the config function instead of the deprecated mappings option
  config = function(_, opts)
    require("obsidian").setup(opts)

    -- Set up keymaps for Obsidian files only
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        local bufnr = vim.api.nvim_get_current_buf()

        -- Check if we're in an Obsidian workspace
        local current_file = vim.fn.expand("%:p")
        local workspace_path = vim.fn.expand(opts.workspaces[1].path)

        if current_file:match(vim.pesc(workspace_path)) then
          -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault
          vim.keymap.set("n", "gf", function()
            return require("obsidian").util.gf_passthrough()
          end, { buffer = bufnr, expr = true, desc = "Obsidian follow link" })

          -- Toggle check-boxes
          vim.keymap.set("n", "<leader>ch", function()
            return require("obsidian").util.toggle_checkbox()
          end, { buffer = bufnr, desc = "Toggle checkbox" })

          -- Smart action depending on context: follow link, show notes with tag, toggle checkbox, or toggle heading fold
          vim.keymap.set("n", "<cr>", function()
            return require("obsidian").util.smart_action()
          end, { buffer = bufnr, expr = true, desc = "Obsidian smart action" })
        end
      end,
    })
  end,
}
