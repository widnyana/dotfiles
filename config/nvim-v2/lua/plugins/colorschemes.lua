-- manage colorscheme plugin using Lazy
local settings = require("config.settings")
local fn = require("utils")

fn.info("using colorscheme: " .. settings.colorscheme)

if settings.colorscheme == "nightfox" then

  return {
    "EdenEast/nightfox.nvim",
    config = function()
      require("config.colorschemes.nightfox")
    end,
  }
elseif settings.colorscheme == "everforest" then
  
  return {
    "neanias/everforest-nvim",
    version = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("everforest").setup()
    end,
  }
elseif settings.theme == "tundra" then
  return {
    "sam4llis/nvim-tundra",
    config = function()
      require("config.colorschemes.tundra")
    end,
  }
elseif settings.theme == "tokyonight" then
  return {
    "folke/tokyonight.nvim",
    branch = "main",
    config = function()
      require("config.colorschemes.tokyonight")
    end,
  }
elseif settings.theme == "kanagawa" then
  return {
    "rebelot/kanagawa.nvim",
    config = function()
      require("config.colorschemes.kanagawa")
    end,
  }
elseif settings.theme == "oxocarbon" then
  return {
    "nyoom-engineering/oxocarbon.nvim",
    config = function()
      vim.opt.background = "dark" -- set this to dark or light
      vim.cmd("colorscheme oxocarbon")
    end,
  }

else
  return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("config.colorschemes.catppuccin")

    end
  }
end
