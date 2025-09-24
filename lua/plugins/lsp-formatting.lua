--  ~/.config/nvim/lua/plugins/lsp-formatting.lua
return {
  -- 1. Make sure the servers/linters/formatters are installed
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "biome",    -- formatter & partial linter
        "vtsls",    -- full TS/JS language server (auto-imports)
        "prettier", -- fallback for non-Biome files
        "eslint_d", -- optional, only if you keep .eslintrc*
      })
    end,
  },

  -- 2. Configure LSP servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Solidity (unchanged)
        solidity_ls_nomicfoundation = {
          filetypes = { "solidity" },
          root_dir = require("lspconfig.util").root_pattern(
            "hardhat.config.js",
            "hardhat.config.ts",
            "foundry.toml",
            "truffle-config.js",
            "package.json",
            ".git"
          ),
          settings = {
            solidity = {
              includePath = "node_modules",
              remapping = {
                ["@openzeppelin/"] = "node_modules/@openzeppelin/",
              },
            },
          },
          on_attach = function(client)
            client.server_capabilities.semanticTokensProvider = nil
          end,
        },

        -- vtsls (handles auto-imports & diagnostics)
        vtsls = {
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
          settings = {
            typescript = {
              checkJs = true, -- <-- HERE
              preferences = {
                importModuleSpecifier = "relative",
                includePackageJsonAutoImports = "on",
              },
              suggest = {
                autoImports = true,
                completeFunctionCalls = true,
              },
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayFunctionParameterTypeHints = true,
              },
            },
            javascript = {
              checkJs = true, -- <-- HERE
              preferences = {
                importModuleSpecifier = "relative",
                includePackageJsonAutoImports = "on",
              },
              suggest = {
                autoImports = true,
                completeFunctionCalls = true,
              },
            },
            vtsls = {
              autoUseWorkspaceTsdk = true, -- <-- HERE
            },
          },
        },

        -- Biome (formatter only, linter kept minimal)
        biome = {
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc" },
          root_dir = require("lspconfig.util").root_pattern("biome.json", ".biome.json", "package.json"),
          single_file_support = false,
          settings = {
            typescript = {
              checkJs = true, -- analyse .js/.jsx
            },
            javascript = {
              checkJs = true, -- ditto
            },
            vtsls = {
              autoUseWorkspaceTsdk = true, -- use workspace TS if present
            },
          },
        },
      },
    },
  },

  -- 3. Formatting via Conform.nvim
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = {
        javascript = { "biome" },
        typescript = { "biome" },
        javascriptreact = { "biome" },
        typescriptreact = { "biome" },
        json = { "biome" },
        jsonc = { "biome" },
        solidity = { "prettier" }, -- prettier + prettier-plugin-solidity
      }

      opts.formatters = opts.formatters or {}
      opts.formatters.prettier = {
        prepend_args = function(_, ctx)
          return ctx.filename:match("%.sol$") and { "--plugin=prettier-plugin-solidity" } or {}
        end,
        timeout_ms = 5000,
      }

      return opts
    end,
  },

  -- 4. Optional: linting with nvim-lint (only if .eslintrc* exists)
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      local has_config = function(patterns)
        for _, p in ipairs(patterns) do
          if vim.fn.filereadable(p) == 1 then
            return true
          end
        end
        local ok, data = pcall(vim.json.decode, table.concat(vim.fn.readfile("package.json"), ""))
        return ok and data and data.eslintConfig
      end

      local eslint_patterns = {
        ".eslintrc.js",
        ".eslintrc.json",
        ".eslintrc.yaml",
        ".eslintrc.yml",
        ".eslintrc",
        "eslint.config.js",
        "eslint.config.mjs",
      }

      if has_config(eslint_patterns) then
        opts.linters_by_ft = {
          javascript = { "eslint_d" },
          typescript = { "eslint_d" },
          javascriptreact = { "eslint_d" },
          typescriptreact = { "eslint_d" },
        }
      end
      return opts
    end,
  },
}
