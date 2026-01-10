-- In ~/.config/nvim/lua/plugins/python.lua
return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        python = { "ruff_format", "ruff_organize_imports" },
      },
    },
  },

  -- Auto-indent Python files before saving
  {
    "neovim/nvim-lspconfig",
    opts = function()
      -- Auto-indent Python on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.py",
        callback = function()
          -- Only auto-indent if there are syntax errors
          local line_count = vim.api.nvim_buf_line_count(0)
          if line_count < 1000 then -- Skip huge files
            vim.cmd("silent! normal! gg=G``")
          end
        end,
        desc = "Auto-indent Python files before save",
      })
    end,
  },
}
