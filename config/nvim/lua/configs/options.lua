local leaderkey = " "

vim.g.mapleader = leaderkey
vim.g.maplocalleader = leaderkey

vim.scriptencoding = 'utf-8'

-- ensure NetRW loaded
vim.g.loaded_netrw = true
vim.g.loaded_netrwPlugin = true

local options ={
--  Backups
    backup = false,                          -- do not creates a backup file
    swapfile = false,                        -- creates a swapfile
    writebackup = false,                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited

--  File treatments
    encoding = 'utf-8',                      -- set file encoding
    fileencoding = "utf-8",                  -- the encoding written to a file
    
--  Search
    hlsearch = true,                         -- highlight all matches on previous search pattern
    incsearch = true,                        -- make search act like search in modern browsers
    ignorecase = true,                       -- ignore case in search patterns
    
    mouse = "a",                             -- allow the mouse to be used in neovim
    
--  UI
    background = "dark",                     -- set this to dark or light
    cmdheight = 1,                           -- more space in the neovim command line for displaying messages
    conceallevel = 0,                        -- so that `` is visible in markdown files
    termguicolors = true,                    -- set term gui colors (most terminals support this)
    pumheight = 10,                          -- pop up menu height
    shiftwidth = 2,                          -- the number of spaces inserted for each indentation
    tabstop = 2,                             -- insert 2 spaces for a tab
    cursorline = true,                       -- highlight the current line
    number = true,                           -- set numbered lines
    relativenumber = false,                  -- set relative numbered lines
    showcmd = false,                         -- Don't show the command in the last line
    ruler = false,                           -- Don't show the ruler
    title = true,                            -- set the title of window to the value of the titlestring
    confirm = true,                          -- confirm to save changes before exiting modified buffer
    softtabstop = 2,
    
--  Editors
    expandtab = true,                        -- convert tabs to spaces
    
--  Behavior
    autoread = true,                         -- Automatically re-read files if unmodified inside Vim.
    smartcase = true,                        -- smart case
    smartindent = true,                      -- make indenting smarter again
    undofile = true,                         -- enable persistent undo
    updatetime = 100,                        -- faster completion (4000ms default)
    foldmethod = "expr",
    foldexpr = "nvim_treesitter#foldexpr()"
}


for k, v in pairs(options) do
    vim.opt[k] = v
end