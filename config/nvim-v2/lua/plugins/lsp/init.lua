-- stolen from https://github.com/NavePnow/dotfiles/blob/5a01522b3e9318598b5548daf21d3a949f4589f4/.config/nvim/lua/plugins/lsp/init.lua
return {
    {
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",              -- nvim-cmp source for neovim builtin LSP client, nvim-cmp is A completion plugin for neovim coded in Lua.
            "williamboman/mason-lspconfig.nvim", -- Extension to mason.nvim that makes it easier to use lspconfig with mason.nvim.
            {
                "SmiteshP/nvim-navbuddy",
                dependencies = {
                    "SmiteshP/nvim-navic",
                    "MunifTanjim/nui.nvim"
                },
                opts = { lsp = { auto_attach = true } }
            }
        },
        config = function(_, _)
            local lsp_utils = require("plugins.lsp.lsp-utils")
            lsp_utils.setup()

            local settings = require("config.settings")
            local mason_lspconfig = require("mason-lspconfig")
            mason_lspconfig.setup({
                ensure_installed = settings.lsp_servers
            })

            local lspconfig = require("lspconfig")
            mason_lspconfig.setup_handlers({
                function(server_name)
                    lspconfig[server_name].setup({
                        on_attach = lsp_utils.on_attach,
                        capabilities = lsp_utils.capabilities,
                    })
                end,
            })
        end
    },
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        opts = {
            pip = {
                upgrade_pip = true,
            },
            ui = {
                border = "rounded",
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        },
        config = function(_, opts)
            require("mason").setup(opts)
            local settings = require("config.settings")

            local mr = require("mason-registry")
            local packages = settings.mason_packages
            local function ensure_installed()
                for _, package in ipairs(packages) do
                    local p = mr.get_package(package)
                    if not p:is_installed() then
                        p:install()
                    end
                end
            end
            if mr.refresh then
                mr.refresh(ensure_installed)
            else
                ensure_installed()
            end
        end,
    },
}
