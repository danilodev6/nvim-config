return {
  "nvim-treesitter/nvim-treesitter",  -- or any plugin (or even dummy)
  config = function()
    vim.filetype.add({
      extension = {
        sol = "solidity",
      },
    })
  end,
}
