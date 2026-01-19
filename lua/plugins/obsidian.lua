return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "DaniloNotes",
        path = os.getenv("OBSIDIAN_PATH") or "~/Developer/work/notes",
      },
    },
    completion = {
      blink = true,
    },
    picker = {
      name = "snacks.pick",
    },

    -- Templates settings
    templates = {
      subdir = "templates",
      date_format = "%Y-%m-%d-%a",
      time_format = "%H:%M",
      tags = "",
    },

    -- ⭐ NEW: Control note creation
    notes_subdir = "recent", -- Optional: put all notes in a subfolder

    -- ⭐ NEW: Use title as filename instead of ID
    note_id_func = function(title)
      -- If title is provided, use it as filename (lowercase, spaces to hyphens)
      if title ~= nil then
        return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        -- If no title, use timestamp
        return tostring(os.time())
      end
    end,

    -- ⭐ NEW: Disable frontmatter ID (or customize it)
    disable_frontmatter = false,
    note_frontmatter_func = function(note)
      -- Customize frontmatter
      local out = {
        id = note.id,
        aliases = note.aliases,
        tags = note.tags,
      }

      -- Add the title if it exists
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end

      return out
    end,
  },

  config = function(_, opts)
    require("obsidian").setup(opts)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local current_file = vim.fn.expand("%:p")
        local workspace_path = vim.fn.expand(opts.workspaces[1].path)

        if current_file:match(vim.pesc(workspace_path)) then
          vim.keymap.set("n", "gf", function()
            return require("obsidian").util.gf_passthrough()
          end, { buffer = bufnr, expr = true, desc = "Obsidian follow link" })

          vim.keymap.set("n", "<leader>ch", function()
            return require("obsidian").util.toggle_checkbox()
          end, { buffer = bufnr, desc = "Toggle checkbox" })

          vim.keymap.set("n", "<cr>", function()
            return require("obsidian").util.smart_action()
          end, { buffer = bufnr, expr = true, desc = "Obsidian smart action" })
        end
      end,
    })
  end,
}
