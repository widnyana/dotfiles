-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.mapleader = " "

vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- Indent
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- clipboard
-- integration works automatically. Requires Neovim >= 0.10.0
vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard

--
vim.opt.inccommand = "split"

-- UI
vim.opt.title = false
vim.opt.cmdheight = 1 -- when using LazyVim, built-in cmd panel is not needed
vim.opt.scrolloff = 10
vim.opt.splitkeep = "cursor"
vim.opt.number = true
vim.opt.wrap = false -- No Wrap line
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.termguicolors = true

-- skip indexing unecessary folders
vim.opt.wildignore:append({
  "*/node_modules/*",
  "*/.venv/*",
  "*/.git/*",
  "*/vendor/*",
})

vim.opt.backupskip = {
  "/tmp/*",
  "/private/tmp/*",
}

-- add asterisk in block comment
vim.opt.formatoptions:append({ "r" })

if vim.fn.has("nvim-0.8") == 1 then
  vim.opt.cmdheight = 0
end

-- custom filetypes mapping
vim.filetype.add({
  pattern = {},
})
