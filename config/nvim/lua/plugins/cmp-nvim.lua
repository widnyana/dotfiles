return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        { 'neovim/nvim-lspconfig' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-path' },
        { 'hrsh7th/cmp-cmdline' },
        { 'williamboman/mason-lspconfig.nvim' },
        { 'b0o/schemastore.nvim' },
        { 'L3MON4D3/LuaSnip' },
        { 'onsails/lspkind.nvim' },
    },
    lazy = true,
    config = function()
        require('lsp-zero.cmp').extend()

        require('cmp').setup({})
    end
}
