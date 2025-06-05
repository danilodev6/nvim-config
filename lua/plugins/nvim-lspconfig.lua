return {
  "neovim/nvim-lspconfig",
  config = function()
    local lspconfig = require("lspconfig")
    lspconfig.solidity.setup({
      cmd = { "/opt/homebrew/bin/solidity-language-server", "--stdio" },
      on_attach = function(client, bufnr)
        print("Solidity LSP attached")
      end,
    })
  end,
}
