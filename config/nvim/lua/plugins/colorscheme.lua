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
}
