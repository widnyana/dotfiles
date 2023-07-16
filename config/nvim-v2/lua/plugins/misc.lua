return {
    { "nvim-lua/plenary.nvim" },                                  -- All the lua functions I don't want to write twice.
    { "MunifTanjim/nui.nvim" },                                   -- UI Component Library for Neovim.
    { "nvim-tree/nvim-web-devicons",     opts = { default = true } }, -- Adds file type icons to Vim plugins
    { "tjdevries/colorbuddy.nvim" },                              -- Your color buddy for making cool neovim color schemes
    { "norcalli/nvim-colorizer.lua" },                            -- The fastest Neovim colorizer.
    
    -- colorschemes
    { "EdenEast/nightfox.nvim" },
    { "neanias/everforest-nvim" },
    { "sam4llis/nvim-tundra" },
    { "folke/tokyonight.nvim" },
    { "rebelot/kanagawa.nvim" },
    { "nyoom-engineering/oxocarbon.nvim" },
    { "catppuccin/nvim" }

    -- Utilities
    -- {
    -- 	"folke/persistence.nvim",
    -- 	lazy = false,
    -- 	keys = {
    -- 		{
    -- 			"<leader>ls",
    -- 			function()
    -- 				require("persistence").load()
    -- 			end,
    -- 		},
    -- 	},
    -- 	opts = { options = { "buffers", "curdir", "folds", "help", "tabpages", "terminal", "globals" } },
    -- },
    -- {
    --     "rmagatti/auto-session",
    --     lazy = false,
    --     opts = {
    --         auto_session_suppress_dirs = { "~/Downloads" },
    --     },
    -- },
}
