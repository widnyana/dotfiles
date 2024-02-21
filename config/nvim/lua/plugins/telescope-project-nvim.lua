-- all in one neovim plugin written in lua that provides superior project management.
-- https://github.com/ahmedkhalf/project.nvim
local M = {
    "ahmedkhalf/project.nvim",
    -- can't use 'opts' because module has non standard name 'project_nvim'
    config = function()
        require("project_nvim").setup({
            -- Manual mode doesn't automatically change your root directory, so you have
            -- the option to manually do so using `:ProjectRoot` command.
            manual_mode = false,

            -- Path where project.nvim will store the project history for use in
            -- telescope
            datapath = vim.fn.stdpath("data"),

            -- Methods of detecting the root directory. **"lsp"** uses the native neovim
            -- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
            -- order matters: if one is not detected, the other is used as fallback. You
            -- can also delete or rearangne the detection methods.
            detection_methods = { "lsp", "pattern" },

            -- Don't calculate root dir on specific directories
            -- Ex: { "~/.cargo/*", ... }
            exclude_dirs = {},

            -- Table of lsp clients to ignore by name
            -- eg: { "efm", ... }
            ignore_lsp = {},

            -- All the patterns used to detect root dir, when **"pattern"** is in
            -- detection_methods
            patterns = {
                ".git",
                ".terraform",
                "Cargo.toml",
                "go.mod",
                "package.json",
                "pyproject.toml",
                "pyrightconfig.json",
                "requirements.yml",
            },

            -- Show hidden files in telescope
            show_hidden = false,
        })
    end,
}

return M
