-- Neovim support for LSP Inlay Hints
-- https://github.com/simrat39/inlay-hints.nvim
return {
  "simrat39/inlay-hints.nvim",
  config = function()
    require("inlay-hints").setup({
      renderer = "inlay-hints/render/eol",
      hints = {
        parameter = {
          show = true,
          highlight = "whitespace",
        },
        type = {
          show = true,
          highlight = "whitespace",
        },
      },
      -- Only show inlay hints for the current line
      only_current_line = false,
      eol = {
        -- whether to align to the extreme right or not
        right_align = false,

        -- padding from the right if right_align is true
        right_align_padding = 7,

        parameter = {
          separator = ", ",
          format = function(hints)
            return string.format(" <- (%s)", hints)
          end,
        },
        type = {
          separator = ", ",
          format = function(hints)
            return string.format(" => %s", hints)
          end,
        },
      },
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("my-inlay-hints", {}),
        callback = function(args)
          local ft = vim.bo[args.buf].filetype
          if ft ~= "go" then
            return
          end

          local client = vim.lsp.get_client_by_id(args.data.client_id)
          require("inlay-hints").on_attach(client, args.buf)
        end,
      })
    })
  end
}
