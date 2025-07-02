local M = {}


--- List enable each language, useful for install only plugins for needed language. Default is all supported languages.
M.enabled_languages = vim.tbl_keys(require('widnyana.config.languages'))

M.flags = {
  debounce_text_changes = 150,
}

return M
