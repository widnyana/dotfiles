local M = {
    "sourcegraph/sg.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim"
    },
    config = function(_, opts)
        require("sg").setup(opts)
    end,
    opts = require("configs.settings").cody_options,
    keys = require("configs.settings").cody_keys,
}


return M
