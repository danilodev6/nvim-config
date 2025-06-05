local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return {}
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

return {
  "jose-elias-alvarez/null-ls.nvim",
  config = function()
    null_ls.setup({
      sources = {
        formatting.prettier.with({
          filetypes = { "solidity" },
        }),
        diagnostics.solhint,
      },
    })
  end,
}
