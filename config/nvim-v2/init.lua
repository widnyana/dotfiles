-- References to ./lua/

-- Check prerequisites
require("config.checks")

require("config.options")

-- Plugin management via lazy
require("config.lazy")

-- "Global" Keymappings
require("config.keymaps")
    

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    -- Vim autocommands/autogroups
    require("config.autocmds")
  end,
})
