return {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
        local settings = require("configs.settings");

        require("nvim-treesitter.configs").setup {

            -- Automatically install missing parsers when entering buffer
            -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
            auto_install = true,

            -- A list of parser names, or "all"
            ensure_installed = settings.treesitter_ensure_installed,

            highlight = {
                enable = true,

                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = false,

                -- list of language that will be disabled
                disable = {},
            },

            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<leader>vv",
                    node_incremental = "+",
                    scope_incremental = false,
                    node_decremental = "_",
                },
            },

            indent = {
                enable = true
            },

            refactor = {
                highlight_definitions = {
                    enable = true,
                    -- Set to false if you have an `updatetime` of ~100.
                    clear_on_cursor_move = true,
                },
                highlight_current_scope = { enable = false },
            },

            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,

            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,

                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ["af"] = { query = "@function.outer", desc = "around a function" },
                        ["if"] = { query = "@function.inner", desc = "inner part of a function" },
                        ["ac"] = { query = "@class.outer", desc = "around a class" },
                        ["ic"] = { query = "@class.inner", desc = "inner part of a class" },
                        ["ai"] = { query = "@conditional.outer", desc = "around an if statement" },
                        ["ii"] = { query = "@conditional.inner", desc = "inner part of an if statement" },
                        ["al"] = { query = "@loop.outer", desc = "around a loop" },
                        ["il"] = { query = "@loop.inner", desc = "inner part of a loop" },
                        ["ap"] = { query = "@parameter.outer", desc = "around parameter" },
                        ["ip"] = { query = "@parameter.inner", desc = "inside a parameter" },
                    },
                    selection_modes = {
                        ["@parameter.outer"] = "v", -- charwise
                        ["@parameter.inner"] = "v", -- charwise
                        ["@function.outer"] = "v",  -- charwise
                        ["@conditional.outer"] = "V", -- linewise
                        ["@loop.outer"] = "V",      -- linewise
                        ["@class.outer"] = "<c-v>", -- blockwise
                    },
                    include_surrounding_whitespace = false,
                },
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_previous_start = {
                        ["[f"] = { query = "@function.outer", desc = "Previous function" },
                        ["[c"] = { query = "@class.outer", desc = "Previous class" },
                        ["[p"] = { query = "@parameter.inner", desc = "Previous parameter" },
                    },
                    goto_next_start = {
                        ["]f"] = { query = "@function.outer", desc = "Next function" },
                        ["]c"] = { query = "@class.outer", desc = "Next class" },
                        ["]p"] = { query = "@parameter.inner", desc = "Next parameter" },
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ["<leader>a"] = "@parameter.inner",
                    },
                    swap_previous = {
                        ["<leader>A"] = "@parameter.inner",
                    },
                },
            }
        }
    end
}
