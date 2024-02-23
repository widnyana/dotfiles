local M = {
  'phaazon/hop.nvim',
  branch = 'v2',
  lazy = false,
  config = function()
    require("hop").setup({
      keys = 'etovxq;pdygfblzhck,isuran',
      case_insensitive = false
    })
  end
}

return M
