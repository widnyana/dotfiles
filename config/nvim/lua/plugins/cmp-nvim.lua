-- A completion engine plugin for neovim written in Lua
return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' }, -- source for text in buffer
    { 'hrsh7th/cmp-path' },   -- source for file system paths
    { 'hrsh7th/cmp-cmdline' },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'b0o/schemastore.nvim' },
    { 'L3MON4D3/LuaSnip' },         -- snippet engine
    { 'saadparwaiz1/cmp_luasnip' }, -- for autocompletion
    { 'onsails/lspkind.nvim' },     -- vs-code like pictograms
  },
  lazy = true,
  config = function()
    local luasnip = require("luasnip")
    local cmp = require('cmp')
    local lspkind = require("lspkind")
    require('lsp-zero.cmp').extend()

    -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      completion = {
        completeopt = "menu,menuone,preview,noselect"
      },
      -- configure how nvim-cmp interacts with snippet engine
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-a>"] = cmp.mapping.complete({ -- autocompletion using cody
          config = {
            sources = {
              { name = "cody" }
            }
          }
        }),
        ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
        ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
        ["<C-e>"] = cmp.mapping({
          i = cmp.mapping.abort(),    -- abort completion window
          c = cmp.mapping.close(),    -- close completion window
        }),
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
      }),
      -- sources for autocompletion
      sources = cmp.config.sources({
        { name = "cody" },
        { name = "nvim_lsp" },
        { name = "luasnip" }, -- snippets
        { name = "buffer" },  -- text within current buffer
        { name = "path" },    -- file system paths
      }),
      -- configure lspkind for vs-code like pictograms in completion menu
      formatting = {
        format = lspkind.cmp_format({
          maxwidth = 50,
          ellipsis_char = "...",
          with_text = true,
          menu = {
            nvim_lsp = "[LSP]",
            cody = "[cody]"
          }
        }),
      },
    })
  end
}
