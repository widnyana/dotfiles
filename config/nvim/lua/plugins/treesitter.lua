local wid_lspconf = require("widnyana.lsp")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    opts = function(_, opts)
      return {
        auto_install = true,
        autotag = {
          enable = true,
        },
        ensure_installed = wid_lspconf.treesitter_ensure_installed,
        event = {
          "BufReadPre",
          "BufNewFile",
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = true,
        },
        indent = {
          enable = true,
        },
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = { "BufWrite", "CursorHold" },
        },
      }
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      -- MDX
      vim.filetype.add({
        extension = {
          mdx = "mdx",
        },
      })
      vim.treesitter.language.register("markdown", "mdx")
    end,
  },
  {

    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, wid_lspconf.mason_ensure_installed)
    end,
  },
}
