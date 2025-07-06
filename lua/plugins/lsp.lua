-- plugins/lsp.lua
return {
  -- Mason for managing LSP servers
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "solidity-ls",
        "efm",
        "prettier",
        "eslint_d",
        "solhint",
        "prettierd",
      })
    end,
  },

  -- Mason LSP Config
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "solidity_ls_nomicfoundation",
        "efm",
      })
    end,
  },

  -- LSP Configuration - Extend LazyVim's config
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Extend LazyVim's diagnostic configuration
      opts.diagnostics = opts.diagnostics or {}
      opts.diagnostics.virtual_text = {
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
      }

      opts.diagnostics.float = {
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
      }

      -- Extend LazyVim's servers configuration
      opts.servers = opts.servers or {}

      -- DISABLE conflicting Solidity servers
      opts.servers.solidity_ls = false
      opts.servers.solidity = false
      opts.servers.solc = false

      -- Add Nomicfoundation Solidity Language Server
      opts.servers.solidity_ls_nomicfoundation = {
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

      -- Enhanced EFM Language Server with better linting output
      opts.servers.efm = {
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
                formatCommand = "prettierd --stdin-filepath ${INPUT}",
                formatStdin = true,
                formatCanRange = true,
              },
            },
            typescript = {
              {
                formatCommand = "prettierd --stdin-filepath ${INPUT}",
                formatStdin = true,
                formatCanRange = true,
              },
            },
            json = {
              {
                formatCommand = "prettierd --stdin-filepath ${INPUT} --parser json",
                formatStdin = true,
                formatCanRange = true,
              },
            },
          },
        },
      }

      return opts
    end,

    -- Add our customizations without interfering with LazyVim's config
    init = function()
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

      -- Add additional keymaps (LazyVim already has most LSP keymaps)
      vim.keymap.set("n", "<space>e", function()
        vim.diagnostic.open_float(nil, { focus = false, border = "rounded" })
      end, { desc = "Show diagnostic in float" })

      -- Test keymap for debugging
      vim.keymap.set("n", "<leader>dt", function()
        vim.cmd("echo 'Diagnostic test works!'")
        vim.diagnostic.open_float(nil, { focus = false, border = "rounded" })
      end, { desc = "Test diagnostic float" })

      -- Custom highlight groups for more muted colors
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
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
      })
    end,
  },

  -- Treesitter for Solidity support
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "solidity",
        "javascript",
        "typescript",
        "json",
      })
    end,
  },
}
