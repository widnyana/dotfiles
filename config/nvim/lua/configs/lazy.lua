local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- ensure Lazy - Modern Plugin Manager
-- (https://github.com/folke/lazy.nvim) is installed 
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- perform plugin instalation and setup
require("lazy").setup("plugins", {
    install = {
        missing = true
    },
    checker = {
        enabled = true,     -- automatically check for plugin updates
        notify = false,     -- get a notification when new updates are found
    },
    change_detection = {
        enabled = true,
        notify = false,
    },
    defaults = { lazy = true },  -- should plugins be lazy-loaded?
    ui = {
        border = "rounded",     -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
        wrap = true,            -- wrap the lines in the ui
        
        size = {                -- a number <1 is a percentage., >1 is a fixed size
            width = 0.7,
            height = 0.7
        },  
    },
    performance = {
        cache = {
            enabled = true,
        },
        reset_packpath = true, -- reset the package path to improve startup time
        rtp = {
            reset = true, -- reset the runtime path to $VIMRUNTIME and your config directory
            -- @type string[] list any plugins you want to disable here
            disabled_plugins = {
                "gzip",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
    dev = {
        path = "~/plugins",
        fallback = false,
    }
})