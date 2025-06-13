-- return {
--   { "williamboman/mason.nvim", version = "1.11.0" },
--   { "williamboman/mason-lspconfig.nvim", version = "1.32.0" },
-- }

-- plugins/mason.lua
-- plugins/mason.lua
return {
  {
    "williamboman/mason.nvim",
    -- Remove version constraint to get latest
    opts = {
      ensure_installed = {
        -- Language servers
        "solidity-ls", -- or "vscode-solidity-server"
        "efm",

        -- Linters
        "solhint",
        "eslint_d",

        -- Formatters
        "prettier",
        "prettierd",
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    -- Remove version constraint to get latest
    opts = {
      ensure_installed = {
        "solidity_ls", -- Mason name for solidity language server
        "efm",
      },
      -- Automatically set up installed servers
      automatic_installation = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Solidity Language Server (Mason will handle the cmd)
        solidity_ls = {
          -- Don't specify cmd - let Mason handle it
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
          single_file_support = true,
        },

        -- EFM Language Server (Mason will handle the cmd)
        efm = {
          -- Don't specify cmd - let Mason handle it
          filetypes = { "solidity", "javascript", "typescript", "json", "yaml" },
          init_options = {
            documentFormatting = true,
            documentRangeFormatting = true,
            hover = true,
            documentSymbol = true,
            codeAction = true,
            completion = true,
          },
          settings = {
            rootMarkers = {
              ".git/",
              "package.json",
              "hardhat.config.js",
              "hardhat.config.ts",
              "truffle-config.js",
              "foundry.toml",
              ".solhint.json",
              ".prettierrc",
              ".prettierrc.json",
            },
            languages = {
              solidity = {
                -- Solhint linter
                {
                  lintCommand = "solhint --formatter compact ${INPUT}",
                  lintStdin = false,
                  lintFormats = {
                    "%f:%l:%c: %t%*[^:]: %m",
                    "%f:%l:%c: %m",
                  },
                  lintIgnoreExitCode = true,
                  lintSource = "solhint",
                  lintSeverity = 1,
                },
                -- Prettier formatter
                {
                  formatCommand = "prettier --stdin --stdin-filepath=${INPUT} --plugin=prettier-plugin-solidity",
                  formatStdin = true,
                  formatCanRange = true,
                },
              },
              javascript = {
                {
                  lintCommand = "eslint_d -f compact --stdin --stdin-filename ${INPUT}",
                  lintStdin = true,
                  lintFormats = { "%f: line %l, col %c, %t%*[^:]: %m" },
                  lintIgnoreExitCode = true,
                  lintSource = "eslint_d",
                },
                {
                  formatCommand = "prettier --stdin --stdin-filepath=${INPUT}",
                  formatStdin = true,
                  formatCanRange = true,
                },
              },
              typescript = {
                {
                  lintCommand = "eslint_d -f compact --stdin --stdin-filename ${INPUT}",
                  lintStdin = true,
                  lintFormats = { "%f: line %l, col %c, %t%*[^:]: %m" },
                  lintIgnoreExitCode = true,
                  lintSource = "eslint_d",
                },
                {
                  formatCommand = "prettier --stdin --stdin-filepath=${INPUT}",
                  formatStdin = true,
                  formatCanRange = true,
                },
              },
              json = {
                {
                  formatCommand = "prettier --stdin --stdin-filepath=${INPUT}",
                  formatStdin = true,
                  formatCanRange = true,
                },
              },
              yaml = {
                {
                  formatCommand = "prettier --stdin --stdin-filepath=${INPUT}",
                  formatStdin = true,
                  formatCanRange = true,
                },
              },
            },
          },
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern(
              "hardhat.config.js",
              "hardhat.config.ts",
              "foundry.toml",
              "truffle-config.js",
              "package.json",
              ".solhint.json",
              ".prettierrc",
              ".prettierrc.json",
              ".git"
            )(fname) or util.path.dirname(fname)
          end,
        },
      },

      -- Setup function for additional configuration
      setup = {
        efm = function(_, opts)
          -- Auto-format on save for supported file types
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              if client and client.name == "efm" then
                local auto_format_filetypes = { "solidity", "javascript", "typescript", "json" }
                if vim.tbl_contains(auto_format_filetypes, vim.bo[args.buf].filetype) then
                  vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = args.buf,
                    callback = function()
                      vim.lsp.buf.format({
                        bufnr = args.buf,
                        filter = function(c)
                          return c.name == "efm"
                        end,
                      })
                    end,
                    desc = "Auto-format with EFM on save",
                  })
                end

                print("EFM attached to " .. vim.bo[args.buf].filetype .. " buffer " .. args.buf)
              end
            end,
          })
        end,
      },
    },
  },
}
