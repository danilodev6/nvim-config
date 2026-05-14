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

  -- Auto-indent + venv picker
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts) -- add (_, opts) here
      opts.servers = opts.servers or {}
      opts.servers.basedpyright = {
        settings = {
          basedpyright = {
            typeCheckingMode = "standard",
          },
        },
      }

      -- Pick nearest venv on opening a Python file
      vim.api.nvim_create_autocmd("VimEnter", {
        pattern = "*.py",
        callback = function(args)
          local root = vim.fs.root(args.buf, { "pyproject.toml", "setup.py", "requirements.txt", ".git" })
              or vim.fn.getcwd()
          for _, name in ipairs({ "venv", ".venv", "env" }) do
            local py = vim.fs.joinpath(root, name, "bin", "python")
            if vim.fn.executable(py) == 1 then
              vim.g.python3_host_prog = py
              return
            end
          end
        end,
      })

      -- Auto-indent Python files before saving
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.py",
        callback = function()
          local line_count = vim.api.nvim_buf_line_count(0)
          if line_count < 1000 then
            vim.cmd("silent! normal! gg=G``")
          end
        end,
        desc = "Auto-indent Python files before save",
      })
    end,
  },
}
