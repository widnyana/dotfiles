-- Enable faster module loading
vim.loader.enable()

-- Capture startup notifications to a persistent log before lazy.nvim loads
require("widnyana.config.logging").setup()

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Run config validation
require("widnyana.config.validation").run()
