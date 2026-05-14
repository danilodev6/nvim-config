return {
  "zbirenbaum/copilot.lua",
  optional = true,
  opts = function()
    require("copilot.api").status = require("copilot.status")
    require("copilot.api").filetypes = {
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
    }
    -- Auto-kill copilot server on nvim exit
    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        local clients = vim.lsp.get_active_clients({ name = "copilot" })
        for _, client in ipairs(clients) do
          client.stop()
        end
      end,
    })
  end,
}
