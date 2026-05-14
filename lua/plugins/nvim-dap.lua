-- This file contains the configuration for the nvim-dap plugin in Neovim.

return {
  {
    -- Plugin: nvim-dap
    -- URL: https://github.com/mfussenegger/nvim-dap
    -- Description: Debug Adapter Protocol client implementation for Neovim.
    "mfussenegger/nvim-dap",
    recommended = true, -- Recommended plugin
    desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",

    dependencies = {
      -- IMPORTANT: nvim-nio MUST be listed first
      "nvim-neotest/nvim-nio",

      -- Plugin: nvim-dap-ui
      -- URL: https://github.com/rcarriga/nvim-dap-ui
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
      },

      -- Plugin: nvim-dap-virtual-text
      -- URL: https://github.com/theHamsta/nvim-dap-virtual-text
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
    },

    -- Keybindings for nvim-dap
    keys = {
      { "<leader>d", "", desc = "+debug", mode = { "n", "v" } }, -- Group for debug commands
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Breakpoint Condition",
      },
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<leader>da",
        function()
          require("dap").continue({ before = get_args })
        end,
        desc = "Run with Args",
      },
      {
        "<leader>dC",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "Run to Cursor",
      },
      {
        "<leader>dg",
        function()
          require("dap").goto_()
        end,
        desc = "Go to Line (No Execute)",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<leader>dj",
        function()
          require("dap").down()
        end,
        desc = "Down",
      },
      {
        "<leader>dk",
        function()
          require("dap").up()
        end,
        desc = "Up",
      },
      {
        "<leader>dl",
        function()
          require("dap").run_last()
        end,
        desc = "Run Last",
      },
      {
        "<leader>do",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>dp",
        function()
          require("dap").pause()
        end,
        desc = "Pause",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "Toggle REPL",
      },
      {
        "<leader>ds",
        function()
          require("dap").session()
        end,
        desc = "Session",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
      {
        "<leader>dw",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "Widgets",
      },
    },

    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Setup dapui
      dapui.setup()

      -- Auto-open/close UI when debugging
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Load mason-nvim-dap if available
      if LazyVim.has("mason-nvim-dap.nvim") then
        require("mason-nvim-dap").setup(LazyVim.opts("mason-nvim-dap.nvim"))
      end

      -- Set highlight for DapStoppedLine
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      -- Define signs for DAP
      for name, sign in pairs(LazyVim.config.icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end

      -- Setup DAP configuration using VsCode launch.json file
      local vscode = require("dap.ext.vscode")
      local json = require("plenary.json")
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end

      -- Load launch configurations from .vscode/launch.json if it exists
      if vim.fn.filereadable(".vscode/launch.json") then
        vscode.load_launchjs()
      end

      -- Function to load environment variables
      local function load_env_variables()
        local variables = {}
        for k, v in pairs(vim.fn.environ()) do
          variables[k] = v
        end

        -- Load variables from .env file manually
        local env_file_path = vim.fn.getcwd() .. "/.env"
        local env_file = io.open(env_file_path, "r")
        if env_file then
          for line in env_file:lines() do
            for key, value in string.gmatch(line, "([%w_]+)=([%w_]+)") do
              variables[key] = value
            end
          end
          env_file:close()
        end
        return variables
      end

      -- Add the env property to each existing Go configuration
      for _, config in pairs(dap.configurations.go or {}) do
        config.env = load_env_variables
      end

      --------------------------------------------------
      -- PYTHON (debugpy)
      --------------------------------------------------
      local venv_python = vim.g.python3_host_prog
          or (vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3"))
          or "python"

      dap.adapters.python = {
        type    = "executable",
        command = venv_python,
        args    = { "-m", "debugpy.adapter" },
      }

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Run current file",
          program = "${file}",
          pythonPath = function()
            -- find nearest venv (same logic as LSP)
            for _, name in ipairs({ "venv", ".venv", "env" }) do
              local py = vim.fn.getcwd() .. "/" .. name .. "/bin/python"
              if vim.fn.filereadable(py) == 1 then return py end
            end
            -- fallback
            return vim.g.python3_host_prog or (vim.fn.exepath("python3") or vim.fn.exepath("python"))
          end,
        },
        -- Para FastAPI/uvicorn
        {
          type       = "python",
          request    = "launch",
          name       = "FastAPI - uvicorn",
          module     = "uvicorn",
          args       = {
            "main:app", -- cambiá main por tu módulo raíz
            "--reload",
            "--port", "8000",
          },
          pythonPath = function()
            for _, name in ipairs({ "venv", ".venv", "env" }) do
              local py = vim.fn.getcwd() .. "/" .. name .. "/bin/python"
              if vim.fn.filereadable(py) == 1 then return py end
            end
            return vim.fn.exepath("python3") or "python"
          end,
          env        = load_env_variables, -- ya la tenés definida arriba
          console    = "integratedTerminal",
        },

        -- Para attacharte a un proceso ya corriendo
        {
          type    = "python",
          request = "attach",
          name    = "Attach to running process",
          connect = { host = "127.0.0.1", port = 5678 },
        },
      }
    end,
  },
}
