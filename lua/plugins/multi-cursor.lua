return {
  -- Option 1: nvim-visual-multi (Most similar to vim-multiple-cursors but faster)
  {
    "mg979/vim-visual-multi",
    branch = "master",
    config = function()
      -- Optional: Configure keymaps
      vim.g.VM_maps = {
        ["Find Under"] = '<C-n>',
        ["Find Subword Under"] = '<C-n>',
        ["Select All"] = '<C-S-n>',
        ["Skip Region"] = '<C-x>',
        ["Remove Region"] = '<C-p>',
      }

      -- Disable default mappings that might conflict
      vim.g.VM_default_mappings = 1

      -- Performance settings
      vim.g.VM_set_statusline = 0 -- Don't change statusline
      vim.g.VM_silent_exit = 1    -- Don't show messages on exit
    end,
  },
}
