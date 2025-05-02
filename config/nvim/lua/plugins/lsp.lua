local python_lsp = "ruff"
local mason_lspconfig = require("mason-lspconfig")

return {
  -- tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "selene",
        "luacheck",
        "rust-analyzer",
        "shellcheck",
        "shfmt",
      })
    end,
  },
  -- lsp servers
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = {
        "gd",
        function()
          -- DO NOT REUSE WINDOW
        end,
        desc = "Goto Definition",
        has = "definition",
      }
    end,
    opts = {
      inlay_hints = { enabled = true },
      servers = {

        biome = {
          root_dir = require("lspconfig").util.root_pattern("biome.json"),
          single_file_support = false,
        },

        -- JSON
        jsonls = {
          schemas = require("schemastore").json.schemas({
            select = {},
          }),
          validate = { enable = true },
        },


        -- LUA
        lua_ls = {
          enabled = true,
          single_file_support = true,
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                workspaceWord = true,
                callSnippet = "Both",
              },
              misc = {
                parameters = {
                  -- "--log-level=trace",
                },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
              doc = {
                privateName = { "^_" },
              },
              type = {
                castNumberToInteger = true,
              },
              diagnostics = {
                disable = { "incomplete-signature-doc", "trailing-space" },
                -- enable = false,
                groupSeverity = {
                  strong = "Warning",
                  strict = "Warning",
                },
                groupFileStatus = {
                  ["ambiguity"] = "Opened",
                  ["await"] = "Opened",
                  ["codestyle"] = "None",
                  ["duplicate"] = "Opened",
                  ["global"] = "Opened",
                  ["luadoc"] = "Opened",
                  ["redefined"] = "Opened",
                  ["strict"] = "Opened",
                  ["strong"] = "Opened",
                  ["type-check"] = "Opened",
                  ["unbalanced"] = "Opened",
                  ["unused"] = "Opened",
                },
                unusedLocalExclude = { "_*" },
                globals = { "vim" },
              },
              format = {
                enable = false,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                  continuation_indent_size = "2",
                },
              },
            },
          },
        },

        -- python
        pyright = {
          enabled = python_lsp == "pyright",
          autostart = python_lsp == "pyright",
          mason = python_lsp == "pyright",
        },

        ruff = {
          enabled = python_lsp == "ruff",
          keys = {},
          settings = {
            configurationPreference = "editorFirst",
            lineLength = 120,
            organizeImports = true,
            logLevel = "error",
            lint = {
              enable = false,
              ignore = {
                "E4",
                "E7",
              },
            },
          },
        },

        -- Rust
        rust_analyzer = {
          on_attach = mason_lspconfig.on_attach,
        },
  

        -- solidity
        solidity = {
          on_attach = mason_lspconfig.on_attach,
          default_config = require("widnyana.plugins.lsp.solidity").opts,
        },

        -- typescript
        tsserver = {
          root_dir = function(...)
            return require("lspconfig.util").root_pattern(".git")(...)
          end,
          on_attach = function(client)
            -- this is important, otherwise tsserver will format ts/js
            -- files which we *really* don't want.
            client.server_capabilities.documentFormattingProvider = false
          end,
          single_file_support = false,
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "literal",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },

        -- YAML
        yamlls = {
          settings = {
            redhat = {
              telemetry = { enabled = false },
            },
            schemas = require("schemastore").yaml.schemas({
              ignore = {},
            }),
            yaml = {
              keyOrdering = false,
              completion = true,
              hover = true,
              validate = true,
              schemaStore = {
                enable = false,
                url = "",
              },
              schemas = require("schemastore").yaml.schemas(),
            },
          },
        },


      },
      setup = {},
      dependencies = {
        "b0o/schemastore.nvim",
      },
    },
  },
  {
    "lervag/vimtex",
    event = "VeryLazy",
    lazy = true,
    config = function()
      vim.g.vimtex_mappings_disable = {
        ["n"] = { "K" }, -- disable "K", conflict with LSP Hover
      }
      vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
    end,
  },

  {
    "simrat39/symbols-outline.nvim",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    cmd = "SymbolsOutline",
    opts = {
      position = "right",
    },
  },
}
