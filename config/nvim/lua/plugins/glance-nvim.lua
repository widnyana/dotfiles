return {
    "dnlhc/glance.nvim",
    config = function()
        require("glance").setup({
            height = 18, -- Height of the window
            zindex = 45,

            -- By default glance will open preview "embedded" within your active window
            -- when `detached` is enabled, glance will render above all existing windows
            -- and won't be restiricted by the width of your active window
            detached = true,

            theme = {
                enable = true,
                mode = 'auto'
            },
            border = {
                enable = true,
                top_char = "─",
                bottom_char = "─",
            },
            list = {
                position = 'right', -- Position of the list window 'left'|'right'
                width = 0.33,       -- 33% width relative to the active window, min 0.1, max 0.5
            },

            folds = {
                fold_closed = '',
                fold_open = '',
                folded = true, -- Automatically fold list on startup
            },
            indent_lines = {
                enable = true,
                icon = '│',
            },
        })
    end,
    keys = {
        { "lD", "<CMD>Glance definitions<CR>",      desc = "Glance definitions" },
        { "lR", "<CMD>Glance references<CR>",       desc = "Glance references" },
        { "lY", "<CMD>Glance type_definitions<CR>", desc = "Glance type_definitions" },
        { "lM", "<CMD>Glance implementations<CR>",  desc = "Glance implementations" }
    }
}
