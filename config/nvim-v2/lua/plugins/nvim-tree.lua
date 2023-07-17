local user_config = require("config.settings")
local icons = require("utils.icons")

local args = {
  diagnostics = {
    enable = true,
    icons = {
      hint = icons.Hint,
      info = icons.Information,
      warning = icons.Warning,
      error = icons.Error,
    },
  },

  view = {
    width = 30,
    number = true,
    relativenumber = user_config.relative_number,
  },
  update_focused_file = {
    enable = true,
  },
  respect_buf_cwd = true,
  git = {
    ignore = true,
  },

  filters = {
    dotfiles = true,
  },
  renderer = {
    group_empty = false,
    highlight_git = true,
    special_files = {},
    icons = {
      glyphs = {
        default = '',
        symlink = icons.symlink,
        git = icons.git_state,
        folder = icons.folder,
      },
    },
  },

}


return {
  "nvim-tree/nvim-tree.lua",
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'nvim-tree'),
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  init = function()
    local map = require('utils').keymap

    map('n', '<C-n>', ':NvimTreeToggle<CR>', { desc = 'Toggle Tree' })
    map('n', '<leader>nt', ':NvimTreeToggle<CR>', { desc = 'Toggle Tree' })
    map('n', '<leader>nr', ':NvimTreeRefresh<CR>', { desc = 'Refresh Tree' })
  end,
  config = function()
    require("nvim-tree").setup(args)
  end,
  cmd = {
    'NvimTreeClipboard',
    'NvimTreeFindFile',
    'NvimTreeOpen',
    'NvimTreeRefresh',
    'NvimTreeToggle',
  },

}
