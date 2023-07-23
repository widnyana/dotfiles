-- References to ./lua/
if vim.fn.has('nvim-0.9') == 0 then
  error('Need Neovim v0.9+ in order to use this configs')
end

-- Check prerequisites
require("config.checks")

local config_modules = {
  "config.options",
  "config.lazy",   -- Plugin management via lazy
  "config.keymaps", -- load mappings only after editor configs are loaded
}


-- set up nvim
for _, mod in ipairs(config_modules) do
  local ok, err = pcall(require, mod)
  -- cosmic.config files may or may not be present
  if not ok and not mod:find('config') then
    error(('Error loading %s...\n\n%s'):format(mod, err))
  end
end

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    -- Vim autocommands/autogroups
    require("config.autocmds")
  end,
})
