return {
    {
        "nyoom-engineering/oxocarbon.nvim",
        lazy = false,
        config = function()
            vim.opt.background = "dark" -- set this to dark or light
        end,
    },
    {
        "neanias/everforest-nvim",
        version = false,
        lazy = false,
        priority = 1000,
        config = function()
            require("everforest").setup({
                ---Controls the "hardness" of the background. Options are "soft", "medium" or "hard".
                ---Default is "medium".
                background = "hard",
                ---How much of the background should be transparent. 2 will have more UI
                ---components be transparent (e.g. status line background)
                transparent_background_level = 0,
                ---Whether italics should be used for keywords and more.
                italics = false,
                ---Disable italic fonts for comments. Comments are in italics by default, set
                ---this to `true` to make them _not_ italic!
                disable_italic_comments = false,
                ---By default, the colour of the sign column background is the same as the as normal text
                ---background, but you can use a grey background by setting this to `"grey"`.
                sign_column_background = "none",
                ---The contrast of line numbers, indent lines, etc. Options are `"high"` or
                ---`"low"` (default).
                ui_contrast = "high",
                ---Dim inactive windows. Only works in Neovim. Can look a bit weird with Telescope.
                dim_inactive_windows = false,
                ---Some plugins support highlighting error/warning/info/hint texts, by
                ---default these texts are only underlined, but you can use this option to
                ---also highlight the background of them.
                diagnostic_text_highlight = false,
                ---Which colour the diagnostic text should be. Options are `"grey"` or `"coloured"` (default)
                diagnostic_virtual_text = "coloured",
                ---Some plugins support highlighting error/warning/info/hint lines, but this
                ---feature is disabled by default in this colour scheme.
                diagnostic_line_highlight = false,
                ---By default, this color scheme won't colour the foreground of |spell|, instead
                ---colored under curls will be used. If you also want to colour the foreground,
                ---set this option to `true`.
                spell_foreground = false,
                ---You can override specific highlights to use other groups or a hex colour.
                ---This function will be called with the highlights and colour palette tables.
                ---@param highlight_groups Highlights
                ---@param palette Palette
                on_highlights = function(highlight_groups, palette) end,
            })
            -- vim.cmd.colorscheme 'everforest'
        end,
    },

    -- Kanagawa Theme
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        enabled = true,
        config = function()
            require("kanagawa").setup({
                overrides = function(colors)
                    local theme = colors.theme
                    return {
                        Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
                        PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
                        PmenuSbar = { bg = theme.ui.bg_m1 },
                        PmenuThumb = { bg = theme.ui.bg_p2 },
                        TelescopeTitle = { fg = theme.ui.special, bold = true },
                        TelescopePromptNormal = { bg = theme.ui.bg_p1 },
                        TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
                        TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
                        TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
                        TelescopePreviewNormal = { bg = theme.ui.bg_dim },
                        TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
                    }
                end,
                colors = {
                    theme = {
                        all = {
                            ui = {
                                bg_gutter = "none"
                            }
                        }
                    }
                }
            })
            -- vim.cmd("colorscheme kanagawa")
        end
    },
    --  Soho vibes for Neovim - https://github.com/rose-pine/neovim
    {
        "rose-pine/neovim",
        config = function()
            require("rose-pine").setup({
                disable_background = true,
                disable_float_background = true,
                dark_variant = "moon",
                disable_italics = true,
                groups = {
                    background = "base",
                    background_nc = "_experimental_nc",
                    panel = "surface",
                    panel_nc = "base",
                    border = "highlight_med",
                    comment = "muted",
                    link = "iris",
                    punctuation = "subtle",

                    error = "love",
                    hint = "iris",
                    info = "foam",
                    warn = "gold",

                    headings = {
                        h1 = "iris",
                        h2 = "foam",
                        h3 = "rose",
                        h4 = "gold",
                        h5 = "pine",
                        h6 = "foam",
                    },
                },
                highlight_groups = {
                    ColorColumn = { bg = "rose" },

                    -- Blend colours against the "base" background
                    CursorLine = { bg = "foam", blend = 10 },
                    StatusLine = { fg = "love", bg = "love", blend = 10 },
                    Search = { bg = "gold", inherit = false },

                    TelescopeBorder = { fg = "highlight_high", bg = "none" },
                    TelescopeNormal = { bg = "none" },
                    TelescopePromptNormal = { bg = "base" },
                    TelescopeResultsNormal = { fg = "subtle", bg = "none" },
                    TelescopeSelection = { fg = "text", bg = "base" },
                    TelescopeSelectionCaret = { fg = "rose", bg = "rose" },
                },
            })

            -- vim.cmd.colorscheme 'rose-pine-moon'
        end,
    },
    {                                 -- make Nvim Transparent
        "xiyaowong/nvim-transparent", -- Remove all background colors to make nvim transparent
        lazy = false,
        config = function()
            require("transparent").setup({
                groups = { -- table: default groups
                    'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
                    'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
                    'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
                    'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
                    'EndOfBuffer',
                },
                extra_groups = {},   -- table: additional groups that should be cleared
                exclude_groups = {}, -- table: groups you don't want to clear
            })

            require('transparent').clear_prefix('lualine')
        end
    }
}
