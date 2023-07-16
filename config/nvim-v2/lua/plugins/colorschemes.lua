-- manage colorscheme plugin using Lazy
return {
  { "ellisonleao/gruvbox.nvim" },
  { "rose-pine/neovim",         name = "rose-pine" },
  {
    "EdenEast/nightfox.nvim",
    config = function()
      require("plugins.colorschemes.nightfox")
    end,
  },
  {
    "neanias/everforest-nvim",
    version = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("everforest").setup()
    end,
  }
  , {
  "sam4llis/nvim-tundra",
  config = function()
    require("plugins.colorschemes.tundra")
  end,
},
  {
    "folke/tokyonight.nvim",
    branch = "main",
    config = function()
      require("plugins.colorschemes.tokyonight")
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    config = function()
      require("plugins.colorschemes.kanagawa")
    end,
  },
  {
    "nyoom-engineering/oxocarbon.nvim",
    config = function()
      vim.opt.background = "dark" -- set this to dark or light
      vim.cmd("colorscheme oxocarbon")
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("plugins.colorschemes.catppuccin")
    end
  }
}
