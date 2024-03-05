return {
  {
    'VonHeikemen/lsp-zero.nvim',
    lazy = true,
    branch = 'v3.x',
    config = false,
    init = function()
      -- Disable automatic setup, we are doing it manually
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },
  {
    'williamboman/mason.nvim',
    lazy = false,
    build = ":MasonUpdate",
    opts = {
      pip = {
        upgrade_pip = true,
      },
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },

    config = function(_, opts)
      require("mason").setup(opts)
      local settings = require("configs.settings")

      local mr = require("mason-registry")
      local packages = settings.mason_packages
      local function ensure_installed()
        for _, package in ipairs(packages) do
          local p = mr.get_package(package)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,

  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    cmd = 'LspInfo',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'williamboman/mason-lspconfig.nvim' },
      { 'b0o/schemastore.nvim' },
      {
        "SmiteshP/nvim-navbuddy", --  A simple popup display that provides breadcrumbs feature using LSP server
        dependencies = {
          "SmiteshP/nvim-navic",  -- A simple statusline/winbar component that uses LSP to show your current code context. Named after the Indian satellite navigation system.
          "MunifTanjim/nui.nvim"  --  UI Component Library for Neovim.
        },
        opts = { lsp = { auto_attach = true } }
      }
    },
    config = function()
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_lspconfig()

      lsp_zero.on_attach(
        function(_, bufnr)
          -- see :help lsp-zero-keybindings
          -- to learn the available actions
          lsp_zero.default_keymaps({ buffer = bufnr })
          local opts = { buffer = bufnr, silent = true }

          vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
          vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
          vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
          vim.keymap.set('n', 'gi', ':Telescope lsp_implementations<cr>', opts)
          vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
          vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', { buffer = bufnr })
          -- vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
          vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
          vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
          --  Formats a buffer using the attached (and optionally filtered) language server clients.
          vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
          vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)

          vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
          vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
          vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
        end
      )

      local lspconfig = require('lspconfig')

      require('mason').setup({})
      require('mason-lspconfig').setup({
        ensure_installed = {
          'tsserver',
          'eslint',
          'rust_analyzer',
          'gopls',
          'lua_ls',
          'jsonls',
          'bashls',
          'vimls',
        },
        handlers = {
          lsp_zero.default_setup,
          -- lua
          lspconfig.lua_ls.setup({
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim", "custom_nvim" },
                },
                workspace = {
                  library = vim.api.nvim_get_runtime_file("", true),
                  checkThirdParty = false,
                  hint = { enable = true },
                  telemetry = { enable = false },
                },
              },
            },
          }),

          -- JSON
          lspconfig.jsonls.setup({
            settings = {
              json = {
                schema = require('schemastore').json.schemas(),
                validate = { enable = true },
              }
            }
          }),

          -- terraform
          lspconfig.terraformls.setup({
            cmd = { "terraform-ls", "serve" },
            filetypes = { "terraform", "tf", "terraform-vars" },
            -- root_dir = lspconfig.util.root_pattern(".terraform", ".git"),
            root_dir = lspconfig.util.root_pattern("*.tf", "*.terraform", "*.tfvars", "*.hcl", "*.config"),
          }),

          lspconfig.marksman.setup({

          })
        }
        -- end handlers
      })

      -- enable format on file save
      lsp_zero.format_mapping('gq', {
        format_opts = {
          async = false,
          timeout_ms = 10000,
        },
        servers = {
          ['lua_ls'] = { 'lua' },
          ['rust_analyzer'] = { 'rust' },
          ['tsserver'] = { 'javascript', 'typescript' },
          ['gopls'] = { 'go' },
        }
      })

      lsp_zero.set_preferences({
        suggest_lsp_servers = false,
      })

      lsp_zero.set_sign_icons({
        error = '✘',
        warn = '▲',
        hint = '⚑',
        info = '»'
      })

      vim.diagnostic.config({
        title            = false,
        underline        = true,
        virtual_text     = true,
        signs            = true,
        update_in_insert = false,
        severity_sort    = true,
        float            = {
          source = "always",
          style = "minimal",
          border = "rounded",
          header = "",
          prefix = "",
        },
      })
    end
  }

}
