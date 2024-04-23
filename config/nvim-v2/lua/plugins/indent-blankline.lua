local M = {
    "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
    opts = {
    indent = { char = "│", highlight = "IblChar" },
    scope = { char = "│", highlight = "IblScopeChar" },
  },
  event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("ibl").setup({
      indent = {
              char = '┊',
          },
    })
    end,
}

return M
