local cmd = vim.cmd
local opt = vim.opt
local g = vim.g
local indent = 2
local user_config = require("config.settings")

cmd([[
    filetype plugin indent on
]])


-- Remap , as leader key
-- Must be before lazy.nvim
g.mapleader = " "
g.maplocalleader = ","


-- misc
opt.backspace = { 'eol', 'start', 'indent' }
opt.clipboard = "unnamedplus"
opt.encoding = 'utf-8'
opt.syntax = 'enable'

-- indention
opt.autoindent = true
opt.expandtab = true
opt.smartindent = true -- smart indent
opt.shiftwidth = indent
opt.softtabstop = indent
opt.tabstop = indent

-- search
opt.ignorecase = true
opt.smartcase = true -- smart case

-- UI
opt.cursorline = true
opt.laststatus = 2
opt.list = true
opt.listchars = {
    tab = '❘-',
    trail = '·',
    lead = '·',
    extends = '»',
    precedes = '«',
    nbsp = '×',
}
opt.number = user_config.number
opt.rnu = user_config.relative_number
opt.scrolloff = 18
opt.sidescrolloff = 5 -- how many lines to scroll when using the scrollbar
opt.showmode = true  -- we don't need to see things like -- INSERT -- anymore
opt.signcolumn = "yes"
opt.wrap = false


-- mouse
opt.mouse = user_config.mouse
opt.mousemoveevent = true

-- backups
opt.backup = false
opt.swapfile = false
opt.writebackup = false


-- autocomplete
opt.completeopt = { "menu", "menuone", "noselect" }
opt.shortmess = opt.shortmess + { c = true }

-- performance
opt.redrawtime = 1500
opt.timeoutlen = 200
opt.ttimeoutlen = 10
opt.updatetime = 100


-- theme
opt.termguicolors = true -- set termguicolors to enable highlight groups

-- vim.o.foldlevelstart = 99
opt.cmdheight = 0
opt.foldenable = true
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99
opt.foldmethod = "expr"
opt.jumpoptions = "view"
opt.pumheight = 10 -- pop up menu height
opt.sessionoptions = "buffers,curdir,folds,help,tabpages,terminal,globals"
opt.spell = false
opt.spelloptions = "camel,noplainbuffer"
opt.splitkeep = "screen"
opt.undofile = true
vim.o.foldcolumn = "1"
opt.fillchars = {
    foldopen = "",
    foldclose = "",
    fold = " ",
    foldsep = " ",
    diff = "/",
    eob = " ",
}


-- command completion
opt.wildmode = "longest:full:full"
opt.wildignore = opt.wildignore + {
    '*/node_modules/*',
    '*/.git/*',
    '*/vendor/*',
    '*.docx',
    '*.jpg',
    '*.png',
    '*.gif',
    '*.pdf',
    '*.pyc',
    '*.exe',
    '*.flv',
    '*.img',
    '*.xlsx',
    '*DS_STORE',
    '*.db'
}
