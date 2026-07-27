-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.mapleader = " "

-- Note: do not set vim.opt.encoding/fileencoding here. Neovim is always
-- utf-8, and setting fileencoding at startup hits E21 (modifiable off) on
-- Neovim 0.12+ during LazyVim's early option load.

-- Indent
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- clipboard
-- integration works automatically. Requires Neovim >= 0.10.0
vim.opt.clipboard = vim.env.SSH_TTY and "unnamed" or "unnamedplus" -- Sync with system clipboard

--
vim.opt.inccommand = "split"
vim.opt.shell = "zsh"
vim.opt.ignorecase = true

-- UI
vim.opt.title = false
vim.opt.cmdheight = 0
vim.opt.scrolloff = 10
vim.opt.showcmd = true
vim.opt.splitkeep = "cursor"
vim.opt.mouse = ""

vim.opt.number = true
vim.opt.wrap = false -- No Wrap line
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.termguicolors = true

vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current

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

-- custom filetypes mapping
vim.filetype.add({
  pattern = {},
})
