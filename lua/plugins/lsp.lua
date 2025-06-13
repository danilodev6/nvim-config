-- plugins/lsp.lua
return {
  -- Mason for managing LSP servers
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "solidity-ls",
        "efm",
        "prettier",
        "eslint_d",
        "solhint",
      },
    },
  },

  -- Mason LSP Config
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "solidity_ls_nomicfoundation",
        "efm",
      },
    },
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Enhanced diagnostic configuration for better styling
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
          -- Custom formatting function for cleaner messages
          format = function(diagnostic)
            local message = diagnostic.message
            -- Clean up solhint messages
            if diagnostic.source == "solhint" then
              -- Remove redundant "ParseError:" prefix if present
              message = message:gsub("^ParseError:%s*", "")
              -- Clean up common solhint patterns
              message = message:gsub("Expected '(.-)' but got '(.-)'", "Expected '%1', got '%2'")
              -- Limit message length for readability
              if #message > 80 then
                message = message:sub(1, 77) .. "..."
              end
            end
            return message
          end,
        },
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
          -- Custom formatting for floating diagnostic window
          format = function(diagnostic)
            local message = diagnostic.message
            local source = diagnostic.source or "LSP"
            local code = diagnostic.code and (" [" .. diagnostic.code .. "]") or ""

            if source == "solhint" then
              message = message:gsub("^ParseError:%s*", "")
              message = message:gsub("Expected '(.-)' but got '(.-)'", "Expected '%1', got '%2'")
            end

            return string.format("%s%s\n\n Source: %s", message, code, source)
          end,
        },
        signs = true,
        severity_sort = true,
      },

      servers = {
        -- DISABLE conflicting Solidity servers
        solidity_ls = false,
        solidity = false,
        solc = false,

        -- Keep only the Nomicfoundation Solidity Language Server
        solidity_ls_nomicfoundation = {
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
        },

        -- Enhanced EFM Language Server with better linting output
        efm = {
          filetypes = { "solidity", "javascript", "typescript", "json" },
          init_options = {
            documentFormatting = true,
            hover = false,
            documentSymbol = false,
            codeAction = false,
            completion = false,
          },
          settings = {
            rootMarkers = { ".git/", "package.json", "hardhat.config.js", "foundry.toml" },
            languages = {
              solidity = {
                {
                  lintCommand = "solhint --formatter compact ${INPUT}",
                  -- Enhanced lint formats for better parsing
                  lintFormats = {
                    "%f:%l:%c: %t%*[^:]: %m",
                    "%f:%l:%c: %m",
                    "%f: line %l, col %c, %t%*[^-] - %m",
                  },
                  lintIgnoreExitCode = true,
                  lintSeverity = 1,
                  lintSource = "solhint",
                  lintStdin = false,
                  -- Add some additional options for better output
                  rootMarkers = { ".solhint.json", "package.json" },
                },
                {
                  formatCommand = "prettier --stdin-filepath ${INPUT} --plugin=prettier-plugin-solidity",
                  formatStdin = true,
                  formatCanRange = true,
                },
              },
              javascript = {
                {
                  formatCommand = "prettier --stdin-filepath ${INPUT}",
                  formatStdin = true,
                  formatCanRange = true,
                },
              },
              typescript = {
                {
                  formatCommand = "prettier --stdin-filepath ${INPUT}",
                  formatStdin = true,
                  formatCanRange = true,
                },
              },
              json = {
                {
                  formatCommand = "prettier --stdin-filepath ${INPUT} --parser json",
                  formatStdin = true,
                  formatCanRange = true,
                },
              },
            },
          },
        },
      },
    },

    -- Add custom configuration after LSP setup
    config = function(_, opts)
      local lspconfig = require("lspconfig")

      -- Apply the configuration
      for server, config in pairs(opts.servers) do
        if config ~= false then
          lspconfig[server].setup(config)
        end
      end

      -- Custom diagnostic signs with single letter icons
      local signs = {
        { name = "DiagnosticSignError", text = "E" },
        { name = "DiagnosticSignWarn", text = "W" },
        { name = "DiagnosticSignHint", text = "H" },
        { name = "DiagnosticSignInfo", text = "I" },
      }

      for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
      end

      -- Configure diagnostics
      vim.diagnostic.config(opts.diagnostics or {})

      -- Add keymaps for better diagnostic navigation (multiple options to avoid conflicts)
      -- Option 1: Simple key without leader
      vim.keymap.set("n", "K", function()
        vim.diagnostic.open_float(nil, { focus = false, border = "rounded" })
      end, { desc = "Show diagnostic in float" })

      -- Option 2: Space-based (if you use space as leader)
      vim.keymap.set("n", "<space>e", function()
        vim.diagnostic.open_float(nil, { focus = false, border = "rounded" })
      end, { desc = "Show diagnostic in float" })

      -- Navigation keys
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
      vim.keymap.set("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "Diagnostics to location list" })

      -- Debug: Simple test that prints to command line
      vim.keymap.set("n", "<leader>t", function()
        vim.cmd("echo 'Keymap works!'")
        vim.diagnostic.open_float(nil, { focus = false, border = "rounded" })
      end, { desc = "Test diagnostic float" })

      -- Custom highlight groups for more muted colors
      vim.cmd([[
        highlight DiagnosticError guifg=#5c6370 guibg=NONE
        highlight DiagnosticWarn guifg=#5c6370 guibg=NONE  
        highlight DiagnosticInfo guifg=#5c6370 guibg=NONE
        highlight DiagnosticHint guifg=#5c6370 guibg=NONE
        highlight DiagnosticVirtualTextError guifg=#4a5568 guibg=NONE
        highlight DiagnosticVirtualTextWarn guifg=#4a5568 guibg=NONE
        highlight DiagnosticVirtualTextInfo guifg=#4a5568 guibg=NONE
        highlight DiagnosticVirtualTextHint guifg=#4a5568 guibg=NONE
        highlight DiagnosticUnderlineError guisp=#2d3748 gui=underline
        highlight DiagnosticUnderlineWarn guisp=#2d3748 gui=underline
        highlight DiagnosticUnderlineInfo guisp=#2d3748 gui=underline
        highlight DiagnosticUnderlineHint guisp=#2d3748 gui=underline
      ]])
    end,
  },

  -- Auto-install prettier-plugin-solidity
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "solidity",
        "javascript",
        "typescript",
        "json",
      },
    },
  },
}
