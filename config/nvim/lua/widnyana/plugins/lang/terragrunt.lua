local enabled_languages = require('widnyana.common').enabled_languages
local language = require('widnyana.config.languages').terragrunt

return vim.list_contains(enabled_languages, 'terragrunt')
    and {
      {
        -- LSP config
        'neovim/nvim-lspconfig',
        opts = {
          servers = {
            terraformls = {},
          },
        },
      },
    }
  or {}
