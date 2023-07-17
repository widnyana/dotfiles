local M = {
    'phaazon/hop.nvim',
    branch = 'v2',
    config = function()
        require("hop").setup({
            keys = 'etovxqpdygfblzhckisuran',
            case_insensitive = false
        })
    end
}

return M
