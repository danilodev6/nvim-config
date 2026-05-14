return {
  {
    -- {
    --   "xiyaowong/transparent.nvim",
    --   config = function()
    --     require("transparent").setup({
    --       extra_groups = { -- table/string: additional groups that should be cleared
    --         "Normal",
    --         "NormalNC",
    --         "Comment",
    --         "Constant",
    --         "Special",
    --         "Identifier",
    --         "Statement",
    --         "PreProc",
    --         "Type",
    --         "Underlined",
    --         "Todo",
    --         "String",
    --         "Function",
    --         "Conditional",
    --         "Repeat",
    --         "Operator",
    --         "Structure",
    --         "LineNr",
    --         "NonText",
    --         "SignColumn",
    --         "CursorLineNr",
    --         "EndOfBuffer",
    --       },
    --       exclude_groups = {}, -- table: groups you don't want to clear
    --     })
    --   end,
    -- },
    {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000,
      opts = {
        flavour = "mocha",             -- latte, frappe, macchiato, mocha
        transparent_background = true, -- disables setting the background color.
        term_colors = true,            -- sets terminal colors (e.g. `g:terminal_color_0`)
      },
    },
    {
      "rose-pine/neovim",
      name = "rose-pine",
      config = function()
        require("rose-pine").setup({
          variant = "moon",      -- auto, main, moon, or dawn
          dark_variant = "moon", -- main, moon, or dawn
          dim_inactive_windows = false,
          extend_background_behind_borders = true,

          enable = {
            terminal = true,
            legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
            migrations = true,        -- Handle deprecated options automatically
          },

          styles = {
            bold = true,
            italic = false,
            transparency = true,
          },

          groups = {
            border = "muted",
            link = "iris",
            panel = "surface",

            error = "love",
            hint = "iris",
            info = "foam",
            note = "pine",
            todo = "rose",
            warn = "gold",

            git_add = "foam",
            git_change = "rose",
            git_delete = "love",
            git_dirty = "rose",
            git_ignore = "muted",
            git_merge = "iris",
            git_rename = "pine",
            git_stage = "iris",
            git_text = "rose",
            git_untracked = "subtle",

            h1 = "iris",
            h2 = "foam",
            h3 = "rose",
            h4 = "gold",
            h5 = "pine",
            h6 = "foam",
          },

          palette = {
            -- Override the builtin palette per variant
            moon = { --     base = '#18191a',
              overlay = "#363738",
              sky = "#7da6ff",
              lightsky = "#c4fffc",
              white = "#ffffff",
              purple = "#eb6f92",
              greenblue = "#31748f",
              teagreen = "#CDEAC0",
              tags = "#C8C8CC",
              rgreen = "#0F5152"
            },
          },

          -- NOTE: Highlight groups are extended (merged) by default. Disable this
          -- per group via `inherit = false`
          highlight_groups = {
            ["solContract"] = { fg = "gold", bold = true },
            ["solBuiltinType"] = { fg = "iris" },
            ["typescriptVariable"] = { fg = "sky" },
            ["javaScriptReserved"] = { fg = "sky" },
            ["@lsp.type.property.typescriptreact"] = { fg = "white" },
            ["typescriptImport"] = { fg = "rgreen" },
            ["tsxTag"] = { fg = "tags" },
            ["tsxIntrinsicTagName"] = { fg = "purple" },
            ["tsxAttrib"] = { fg = "greenblue" },
            ["tsxTagName"] = { fg = "teagreen" }

            -- Comment = { fg = "foam" },
            -- StatusLine = { fg = "love", bg = "love", blend = 15 },
            -- VertSplit = { fg = "muted", bg = "muted" },
            -- Visual = { fg = "base", bg = "text", inherit = false },
          },

          before_highlight = function(group, highlight, palette)
            -- Disable all undercurls
            -- if highlight.undercurl then
            --     highlight.undercurl = false
            -- end
            --
            -- Change palette colour
            -- if highlight.fg == palette.pine then
            --     highlight.fg = palette.foam
            -- end
          end,
        })
      end,
    },
    {
      "Gentleman-Programming/gentleman-kanagawa-blur",
      name = "gentleman-kanagawa-blur",
      priority = 1000,
    },
    {
      "Alan-TheGentleman/oldworld.nvim",
      lazy = false,
      priority = 1000,
      opts = {},
    },
    {
      "rebelot/kanagawa.nvim",
      priority = 1000,
      name = "kanagawa",
      lazy = true,
      config = function()
        require("kanagawa").setup({
          compile = false,  -- enable compiling the colorscheme
          undercurl = true, -- enable undercurls
          commentStyle = { italic = true },
          functionStyle = {},
          keywordStyle = { italic = true },
          statementStyle = { bold = true },
          typeStyle = {},
          transparent = true,    -- do not set background color
          dimInactive = false,   -- dim inactive window `:h hl-NormalNC`
          terminalColors = true, -- define vim.g.terminal_color_{0,17}
          colors = {             -- add/modify theme and palette colors
            palette = {},
            theme = {
              wave = {},
              lotus = {},
              dragon = {},
              all = {
                ui = {
                  bg_gutter = "none",  -- set bg color for normal background
                  bg_sidebar = "none", -- set bg color for sidebar like nvim-tree
                  bg_float = "none",   -- set bg color for floating windows
                },
              },
            },
          },
          overrides = function(colors) -- add/modify highlights
            return {
              LineNr = { bg = "none" },
              NormalFloat = { bg = "none" },
              FloatBorder = { bg = "none" },
              FloatTitle = { bg = "none" },
              TelescopeNormal = { bg = "none" },
              TelescopeBorder = { bg = "none" },
              LspInfoBorder = { bg = "none" },
            }
          end,
          theme = "wave",  -- Load "wave" theme
          background = {   -- map the value of 'background' option to a theme
            dark = "wave", -- try "dragon" !
            light = "lotus",
          },
        })
      end,
    },
    -- {
    --   -- LazyVim configuration
    --   "LazyVim/LazyVim",
    --   opts = {
    --     -- Set the default color scheme
    --     colorscheme = "rose-pine",
    --   },
    -- },

    {
      "LazyVim/LazyVim",
      opts = {
        colorscheme = "kanagawa-dragon",
      },
    },
  }
}
