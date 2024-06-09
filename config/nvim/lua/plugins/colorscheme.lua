return {
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = true,
    priority = 1000,
    opts = function()
      return {
        transparent = true,
        terminal_colors = true,
        sidebars = { "qf", "help" },
        day_brightness = 0.4,
        dim_inactive = true,
        lualine_bold = false,
        styles = {
          sidebars = "dark",
        },
      }
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    priority = 1000,
    opts = function()
      return {
        terminal_colors = true,
      }
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    priority = 1000,
    opts = function()
      return {
        compile = true,
        undercurl = true,
        commentStyle = { italic = true },
        statementStyle = { bold = true },
        transparent = false, -- do not set background colors
        dimInactive = false, -- dim inactive window `:h hl-NormalNC`
        theme = "wave", -- Load "wave" theme when 'background' option is not set
        background = { -- map the value of 'background' option to a theme
          dark = "wave", -- try "dragon" !
          light = "lotus",
        },
      }
    end,
  },
}
