return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      -- Configure linters for JavaScript/TypeScript files
      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      }

      -- Enhanced eslint_d detection
      lint.linters.eslint_d = {
        cmd = function()
          -- 1. Check local project installation
          local project_bin = vim.fn.getcwd() .. "/node_modules/.bin/eslint_d"
          if vim.fn.executable(project_bin) == 1 then
            return project_bin
          end

          -- 2. Check global installation
          return "eslint_d"
        end,
        stdin = true,
        args = {
          "--format",
          "json",
          "--stdin",
          "--stdin-filename",
          function()
            return vim.api.nvim_buf_get_name(0)
          end,
        },
        ignore_exitcode = true,
        parser = function(output)
          local ok, decoded = pcall(vim.json.decode, output)
          if not ok then
            return {}
          end

          local diagnostics = {}
          for _, item in ipairs(decoded) do
            if item.messages then
              for _, msg in ipairs(item.messages) do
                table.insert(diagnostics, {
                  lnum = (msg.line or 1) - 1,
                  col = (msg.column or 1) - 1,
                  end_lnum = (msg.endLine or msg.line or 1) - 1,
                  end_col = (msg.endColumn or msg.column or 1) - 1,
                  severity = msg.severity == 2 and vim.diagnostic.severity.ERROR or vim.diagnostic.severity.WARN,
                  message = msg.message,
                  source = "eslint",
                  code = msg.ruleId,
                })
              end
            end
          end
          return diagnostics
        end,
      }

      -- Setup autocmds
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          lint.try_lint()
        end,
      })

      -- Create user commands
      vim.api.nvim_create_user_command("LintNow", function()
        lint.try_lint()
      end, {})
    end,
  },
}
