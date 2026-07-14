-- nvim.lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup("plugins", {
    install = {
        colorscheme = {
            "catppuccin",
            "tokyonight",
            "habamax"
        },
        missing = true
    },
    defaults = { lazy = false },
    ui = {
        border = "rounded",
        size = { width = 0.7, height = 0.7 },
        icons = {
            cmd = "⌘",
            config = "🛠 ",
            event = "📅",
            ft = "📂",
            init = "⚙",
            keys = "🗝 ",
            plugin = "🔌",
            runtime = "💻",
            source = "📄",
            start = "🚀",
            task = "📌",
            lazy = "💤 ",
        }
    },
    checker = { enabled = true },
    debug = false,
    performance = {
        cache = {
            enabled = true,
        },
        rtp = {
            disabled_plugins = {
                '2html_plugin',
                'gzip',
                'logipat',
                'matchit',
                'netrw',
                'netrwFileHandlers',
                'netrwPlugin',
                'netrwSettings',
                'rrhelper',
                'spellfile_plugin',
                'tar',
                'tarPlugin',
                'zip',
                'zipPlugin',
                "gzip",
                "toHtml",
                "tutor",
            }
        }
    },
    spec = {
        -- import/override with your plugins configuration inside "lua/plugins" directory
        { import = "plugins" },
    }

})
