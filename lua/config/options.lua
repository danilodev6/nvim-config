-- LSP Server to use for Python
-- Options: "pyright" (default) or "basedpyright" (community fork with more features)
vim.g.lazyvim_python_lsp = "basedpyright"

-- Ruff version to use
-- Options: "ruff" (native LSP) or "ruff_lsp" (deprecated older version)
vim.g.lazyvim_python_ruff = "ruff"

vim.g.python3_host_prog = vim.fn.expand("~/.nvim-python/bin/python")

vim.api.nvim_set_hl(0, 'MiniIconsYellow', { fg = '#FFFF00' })
