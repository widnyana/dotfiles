return {
    { "nvim-lua/plenary.nvim" },                                  -- All the lua functions I don't want to write twice.
    { "MunifTanjim/nui.nvim" },                                   -- UI Component Library for Neovim.
    { "nvim-tree/nvim-web-devicons",     opts = { default = true } }, -- Adds file type icons to Vim plugins
    { "tjdevries/colorbuddy.nvim" },                              -- Your color buddy for making cool neovim color schemes
    { "norcalli/nvim-colorizer.lua" },                            -- The fastest Neovim colorizer.
    
    -- colorschemes
    { "catppuccin/nvim" },
    { "EdenEast/nightfox.nvim" },
    { "folke/tokyonight.nvim" },
    { "neanias/everforest-nvim" },
    { "nyoom-engineering/oxocarbon.nvim" },
    { "rebelot/kanagawa.nvim" },
    { "sam4llis/nvim-tundra" },

    -- Utilities
    {
        "folke/persistence.nvim",
        lazy = false,
        keys = {
            {
                "<leader>ls",
                function()
                    require("persistence").load()
                end,
            },
        },
        opts = { options = { "buffers", "curdir", "folds", "help", "tabpages", "terminal", "globals" } },
    },
    -- {
    --     "rmagatti/auto-session",
    --     lazy = false,
    --     opts = {
    --         auto_session_suppress_dirs = { "~/Downloads" },
    --     },
    -- },
}
