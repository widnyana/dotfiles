return {
    "ThePrimeagen/refactoring.nvim",  --  The Refactoring library based off the Refactoring book by Martin Fowler 
    dependencies = {
        {"nvim-lua/plenary.nvim"},
        {"nvim-treesitter/nvim-treesitter"}
    },
    config = function()
        require("refactoring").setup({})
    end
}