local user_config = require("configs.settings")
local icons = require("configs.ui.icons")

local args = {
  diagnostics = {
    enable = false,
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
    side = "right",
    relativenumber = user_config.relative_number,
  },
  update_focused_file = {
    enable = true,
    update_root = true
  },
  respect_buf_cwd = true,
  git = {
    ignore = true,
    enable = true,
  },
  filters = {
    dotfiles = true,
  },
  renderer = {
    group_empty = false,
    highlight_git = true,
    special_files = {},
    icons = {
      show = {
        git = true,
      },
      glyphs = {
        default = '',
        symlink = icons.symlink,
        git = icons.git_state,
        folder = icons.folder,
      },
    },
  },
  sync_root_with_cwd = true,
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
