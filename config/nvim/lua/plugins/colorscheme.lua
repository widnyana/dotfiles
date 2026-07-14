return {
  {
    "zaldih/themery.nvim",
    lazy = false,
    config = function()
      require("themery").setup({
        livePreview = true, -- Apply theme while picking. Default to true.
        themes = {
          "kanagawa-lotus",
          "kanagawa-dragon",
          "rose-pine-dawn",
          "rose-pine",
          "rose-pine-moon",
          "rose-pine-main",
          "catppuccin-macchiato",
          "tundra",
          "everforest",
          "oxocarbon",
        },
      })
    end,
  },
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    opts = function()
      return {
        style = "storm",
        transparent = true,
        terminal_colors = true,
        day_brightness = 0.6,
        dim_inactive = true, -- dims inactive windows
        lualine_bold = true, -- When `true`, section headers in the lualine theme will be bold
        sidebars = { "qf", "vista_kind", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
        styles = {
          -- Style to be applied to different syntax groups
          -- Value is any valid attr-list value for `:help nvim_set_hl`
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
          -- Background styles. Can be "dark", "transparent" or "normal"
          sidebars = "normal", -- style for sidebars, see below
          floats = "dark", -- style for floating windows
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
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,

    opts = function()
      return {
        variant = "moon",
        enable = {
          terminal = true,
          legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
          migrations = true, -- Handle deprecated options automatically
        },
      }
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    priority = 1000,
    opts = function()
      return {
        flavour = "macchiato",
        dim_inactive = {
          enabled = true,
          shade = "dark",
          percentage = 0.15,
        },
        transparent_background = false,
        term_colors = true,
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
        },
        integrations = {
          treesitter = true,
          native_lsp = { enabled = true },
          cmp = true,
          gitsigns = true,
          telescope = true,
          neotree = { enabled = true },
          which_key = true,
          indent_blankline = { enabled = true },
          notify = true,
          symbols_outline = true,
          mini = true,
        },
      }
    end,
  },
  {
    "sam4llis/nvim-tundra",
    lazy = true,
    priority = 1000,
    opts = function()
      return {
        transparent_background = false,
        editor = {
          search = {},
          substitute = {},
        },
        syntax = {
          booleans = { bold = true, italic = true },
          comments = { bold = true, italic = true },
          conditionals = {},
          constants = { bold = true },
          functions = {},
          keywords = {},
          loops = {},
          numbers = { bold = true },
          operators = { bold = true },
          punctuation = {},
          strings = {},
          types = { italic = true },
        },
        diagnostics = {
          errors = {},
          warnings = {},
          information = {},
          hints = {},
        },
        plugins = {
          lsp = true,
          treesitter = true,
          cmp = true,
          context = true,
          gitsigns = true,
          telescope = true,
        },
        overwrite = {
          colors = {},
          highlights = {},
        },
      }
    end,
  },
  {
    "neanias/everforest-nvim",
    lazy = true,
    priority = 1000,
    opts = {},
  },
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = true,
    priority = 1000,
  },
}
