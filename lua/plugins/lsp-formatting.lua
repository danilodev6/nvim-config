-- plugins/lsp-formatting.lua
-- Consolidated LSP and formatting configuration for LazyVim

return {
  -- Mason setup
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- Language servers
        "solidity-ls",

        -- Formatters
        "prettier",
        "prettierd",

        -- Linters
        "eslint_d",
        "solhint",
      })
    end,
  },

  -- LSP Config
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Extend servers
      opts.servers = opts.servers or {}

      -- Solidity Language Server
      opts.servers.solidity_ls = {
        filetypes = { "solidity" },
        root_dir = function(fname)
          local util = require("lspconfig.util")
          return util.root_pattern(
            "hardhat.config.js",
            "hardhat.config.ts",
            "foundry.toml",
            "truffle-config.js",
            "package.json",
            ".git"
          )(fname)
        end,
      }

      return opts
    end,
  },

  -- Conform.nvim for formatting (LazyVim's preferred formatter)
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}

      -- Add your custom formatters
      opts.formatters_by_ft.solidity = { "prettier" }
      opts.formatters_by_ft.javascript = { "prettierd", "prettier" }
      opts.formatters_by_ft.typescript = { "prettierd", "prettier" }
      opts.formatters_by_ft.json = { "prettierd", "prettier" }

      -- Configure prettier for Solidity
      opts.formatters = opts.formatters or {}
      opts.formatters.prettier = {
        prepend_args = function(self, ctx)
          local args = {}
          -- Add Solidity plugin if it's a .sol file
          if ctx.filename and ctx.filename:match("%.sol$") then
            table.insert(args, "--plugin=prettier-plugin-solidity")
          end
          return args
        end,
      }

      return opts
    end,
  },

  -- Lint configuration
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}

      -- Add your linters
      opts.linters_by_ft.solidity = { "solhint" }
      opts.linters_by_ft.javascript = { "eslint_d" }
      opts.linters_by_ft.typescript = { "eslint_d" }
      opts.linters_by_ft.javascriptreact = { "eslint_d" }
      opts.linters_by_ft.typescriptreact = { "eslint_d" }

      return opts
    end,
  },
}
