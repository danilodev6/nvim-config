-- This file contains custom key mappings for Neovim.

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Position cursor at the middle of the screen after scrolling half page
vim.keymap.set("n", "<C-d>", "<C-d>zz") -- Scroll down half a page and center the cursor
vim.keymap.set("n", "<C-u>", "<C-u>zz") -- Scroll up half a page and center the cursor

-- Map Ctrl+b in insert mode to delete to the end of the word without leaving insert mode
vim.keymap.set("i", "<C-b>", "<C-o>de")

-- Map Ctrl+c to escape from other modes
vim.keymap.set({ "i", "n", "v" }, "<C-c>", [[<C-\><C-n>]])

-- Screen Keys
vim.keymap.set({ "n" }, "<leader>uk", "<cmd>Screenkey<CR>")

----- Tmux Navigation ------
local nvim_tmux_nav = require("nvim-tmux-navigation")

vim.keymap.set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft) -- Navigate to the left pane
vim.keymap.set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown) -- Navigate to the bottom pane
vim.keymap.set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp) -- Navigate to the top pane
vim.keymap.set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight) -- Navigate to the right pane
vim.keymap.set("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive) -- Navigate to the last active pane
vim.keymap.set("n", "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext) -- Navigate to the next pane

----- OBSIDIAN -----
vim.keymap.set("n", "<leader>oc", "<cmd>ObsidianCheck<CR>", { desc = "Obsidian Check Checkbox" })
vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianTemplate<CR>", { desc = "Insert Obsidian Template" })
vim.keymap.set("n", "<leader>oo", "<cmd>Obsidian Open<CR>", { desc = "Open in Obsidian App" })
vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<CR>", { desc = "Show ObsidianBacklinks" })
vim.keymap.set("n", "<leader>ol", "<cmd>ObsidianLinks<CR>", { desc = "Show ObsidianLinks" })
vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<CR>", { desc = "Create New Note" })
vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<CR>", { desc = "Search Obsidian" })
vim.keymap.set("n", "<leader>oq", "<cmd>ObsidianQuickSwitch<CR>", { desc = "Quick Switch" })

----- OIL -----
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Delete all buffers but the current one
vim.keymap.set(
  "n",
  "<leader>bq",
  '<Esc>:%bdelete|edit #|normal`"<Return>',
  { desc = "Delete other buffers but the current one" }
)

-- Disable key mappings in insert mode
vim.api.nvim_set_keymap("i", "<A-j>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<A-k>", "<Nop>", { noremap = true, silent = true })

-- Disable key mappings in normal mode
vim.api.nvim_set_keymap("n", "<A-j>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-k>", "<Nop>", { noremap = true, silent = true })

-- Disable key mappings in visual block mode
vim.api.nvim_set_keymap("x", "<A-j>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "<A-k>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "J", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "K", "<Nop>", { noremap = true, silent = true })

-- Redefine Ctrl+s to save with the custom function
vim.api.nvim_set_keymap("n", "<C-s>", ":lua SaveFile()<CR>", { noremap = true, silent = true })

-- Custom save function
function SaveFile()
  -- Check if a buffer with a file is open
  if vim.fn.empty(vim.fn.expand("%:t")) == 1 then
    vim.notify("No file to save", vim.log.levels.WARN)
    return
  end

  local filename = vim.fn.expand("%:t") -- Get only the filename
  local success, err = pcall(function()
    vim.cmd("silent! write") -- Try to save the file without showing the default message
  end)

  if success then
    vim.notify(filename .. " Saved!") -- Show only the custom message if successful
  else
    vim.notify("Error: " .. err, vim.log.levels.ERROR) -- Show the error message if it fails
  end
end

-- Add this to the end of your keymaps.lua file

----- SOLIDITY CONFIG INJECTION -----
local function inject_solidity_configs()
  local cwd = vim.fn.getcwd()

  -- .solhint.json content
  local solhint_content = [[{
  "extends": "solhint:recommended",
  "rules": {
    "avoid-low-level-calls": "warn",
    "avoid-sha3": "warn",
    "avoid-suicide": "error",
    "avoid-throw": "error",
    "avoid-tx-origin": "warn",
    "check-send-result": "error",
    "func-visibility": ["error", { "ignoreConstructors": true }],
    "mark-callable-contracts": "warn",
    "multiple-sends": "warn",
    "reentrancy": "warn",
    "state-visibility": "error",
    "use-forbidden-name": "error",
    "bracket-align": "error",
    "code-complexity": ["error", 8],
    "const-name-snakecase": "error",
    "contract-name-camelcase": "error",
    "event-name-camelcase": "error",
    "func-name-mixedcase": "error",
    "func-order": "error",
    "func-param-name-mixedcase": "error",
    "modifier-name-mixedcase": "error",
    "private-vars-leading-underscore": "error",
    "var-name-mixedcase": "error",
    "compiler-version": ["error", "^0.8.0"],
    "not-rely-on-time": "warn",
    "avoid-call-value": "warn",
    "comprehensive-interface": "off",
    "no-empty-blocks": "error",
    "reason-string": ["warn", { "maxLength": 64 }],
    "gas-custom-errors": "warn",
    "max-line-length": ["error", 120],
    "no-console": "warn",
    "no-global-import": "error",
    "quotes": ["error", "double"],
    "semicolon": ["error", "always"],
    "no-unused-vars": "warn",
    "explicit-types": "off",
    "immutable-vars-naming": "error"
  },
  "plugins": [],
  "excludedFiles": [
    "node_modules/**",
    "artifacts/**",
    "cache/**",
    "typechain/**",
    "dist/**"
  ]
}]]

  -- .prettierrc.json content
  local prettier_content = [[{
  "plugins": ["prettier-plugin-solidity"],
  "overrides": [
    {
      "files": "*.sol",
      "options": {
        "parser": "solidity-parse",
        "printWidth": 120,
        "tabWidth": 4,
        "useTabs": false,
        "singleQuote": false,
        "bracketSpacing": true,
        "explicitTypes": "always"
      }
    },
    {
      "files": ["*.js", "*.ts"],
      "options": {
        "printWidth": 100,
        "tabWidth": 2,
        "useTabs": false,
        "semi": true,
        "singleQuote": true,
        "quoteProps": "as-needed",
        "trailingComma": "es5",
        "bracketSpacing": true,
        "bracketSameLine": false,
        "arrowParens": "avoid"
      }
    },
    {
      "files": "*.json",
      "options": {
        "printWidth": 80,
        "tabWidth": 2,
        "useTabs": false,
        "semi": false,
        "singleQuote": false,
        "trailingComma": "none"
      }
    }
  ],
  "printWidth": 100,
  "tabWidth": 2,
  "useTabs": false,
  "semi": true,
  "singleQuote": true,
  "quoteProps": "as-needed",
  "trailingComma": "es5",
  "bracketSpacing": true,
  "bracketSameLine": false,
  "arrowParens": "avoid",
  "endOfLine": "lf"
}]]

  -- Write .solhint.json
  local solhint_path = cwd .. "/.solhint.json"
  local solhint_file = io.open(solhint_path, "w")
  if solhint_file then
    solhint_file:write(solhint_content)
    solhint_file:close()
    vim.notify(".solhint.json created successfully!", vim.log.levels.INFO)
  else
    vim.notify("Failed to create .solhint.json", vim.log.levels.ERROR)
    return
  end

  -- Write .prettierrc.json
  local prettier_path = cwd .. "/.prettierrc.json"
  local prettier_file = io.open(prettier_path, "w")
  if prettier_file then
    prettier_file:write(prettier_content)
    prettier_file:close()
    vim.notify(".prettierrc.json created successfully!", vim.log.levels.INFO)
  else
    vim.notify("Failed to create .prettierrc.json", vim.log.levels.ERROR)
    return
  end

  vim.notify("Solidity configs injected successfully! 🚀", vim.log.levels.INFO)
end

-- Keymap to inject solidity configs
vim.keymap.set(
  "n",
  "<leader>cI",
  inject_solidity_configs,
  { desc = "Inject Solidity configs (.solhint.json & .prettierrc.json)" }
)
