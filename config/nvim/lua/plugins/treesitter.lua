local wid_lspconf = require("widnyana.lsp")

-- MDX
vim.filetype.add({
  extension = {
    mdx = "mdx",
  },
})
vim.treesitter.language.register("markdown", "mdx")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = wid_lspconf.treesitter_ensure_installed,
    },
  },
}
