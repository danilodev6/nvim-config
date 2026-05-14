-- LSP Server to use for Python
vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = "ruff"
vim.g.python3_host_prog = vim.fn.expand("~/.nvim-python/bin/python")
vim.api.nvim_set_hl(0, 'MiniIconsYellow', { fg = '#FFFF00' })

-- Diagnostics: hide inline virtual text, keep gutter signs only
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
