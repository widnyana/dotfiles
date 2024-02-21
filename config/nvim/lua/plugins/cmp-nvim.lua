return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        { 'neovim/nvim-lspconfig' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-path' },
        { 'hrsh7th/cmp-cmdline' },
        { 'williamboman/mason-lspconfig.nvim' },
        { 'b0o/schemastore.nvim' }
    },
    lazy = true,
    config = function()
        require('cmp').setup({})
    end
}
