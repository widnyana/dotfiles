return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    version = false,
    lazy = true,
    dependencies = {
      'nvim-lua/plenary.nvim',                                        --  https://github.com/nvim-lua/plenary.nvim
      'jvgrootveld/telescope-zoxide',                                 --  An extension for telescope.nvim that allows you operate zoxide within Neovim.
      'nvim-tree/nvim-web-devicons',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }, --  FZF sorter for telescope written in c
      'nvim-telescope/telescope-ui-select.nvim',                      -- sets vim.ui.select to telescope
      'kkharji/sqlite.lua',                                           --  SQLite LuaJIT binding with a very simple api.
      'nvim-telescope/telescope-frecency.nvim',                       -- extension that offers intelligent prioritization when selecting files from your editing history
      'crispgm/telescope-heading.nvim',                               -- An extension for telescope.nvim that allows you to switch between headings
      'nvim-telescope/telescope-project.nvim',                        -- An extension for telescope.nvim that allows you to switch between projects.
      -- {
      --   "nvim-telescope/telescope-file-browser.nvim",
      --   dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
      -- }
    },
    config = function()
      local telescope = require('telescope')
      local telescopeConfig = require("telescope.config")
      local actions = require('telescope.actions')
      local action_layout = require("telescope.actions.layout")
      local trouble = require("trouble.providers.telescope")

      -- extensions
      local fb_actions = require("telescope").extensions.file_browser.actions
      local project_actions = require("telescope._extensions.project.actions")

      -- user configs
      local settings = require("configs.settings")
      local icons = require("configs.ui.icons")

      -- local configs construction
      local telescope_local_config = {
        file_browser_opts = {
          theme = "ivy",
          -- disables netrw and use telescope-file-browser in its place
          hijack_netrw = true,
          hidden = true,
          mappings = {

            ["i"] = {
              ["<c-n>"] = fb_actions.create,
              ["<c-r>"] = fb_actions.rename,
              -- ["<c-h>"] = actions.which_key,
              ["<c-h>"] = fb_actions.toggle_hidden,
              ["<c-x>"] = fb_actions.remove,
              ["<c-p>"] = fb_actions.move,
              ["<c-y>"] = fb_actions.copy,
              ["<c-a>"] = fb_actions.select_all,


            }
          }
        }
      }


      local vimgrep_arguments = { table.unpack(telescopeConfig.values.vimgrep_arguments) }
      if settings.telescope_grep_hidden then
        table.insert(vimgrep_arguments, "--hidden")
      end

      -- trim the indentation at the beginning of presented line
      table.insert(vimgrep_arguments, "--trim")


      telescope.setup {
        defaults = {
          mappings = {
            i = {
              -- Close on first esc instead of going to normal mode
              -- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua
              ["<esc>"] = actions.close,
              ["<C-j>"] = actions.move_selection_next,
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_selected_to_qflist,
              ["<C-l>"] = actions.send_to_qflist,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<cr>"] = actions.select_default,
              ["<c-v>"] = actions.select_vertical,
              ["<c-s>"] = actions.select_horizontal,
              ["<c-t>"] = actions.select_tab,
              ["<c-p>"] = action_layout.toggle_preview,
              ["<c-o>"] = action_layout.toggle_mirror,
              ["<c-h>"] = actions.which_key,
              ["<c-x>"] = actions.delete_buffer,
            },
            n = { ["<C-t>"] = trouble.open_with_trouble },
          },
          previewer = false,
          -- hidden = true,
          prompt_prefix = "   ",
          file_ignore_patterns = { "node_modules", "package-lock.json", ".venv", ".git" },
          initial_mode = "insert",
          select_strategy = "reset",
          sorting_strategy = "ascending",
          -- layout_strategy = "horizontal",
          layout_config = {
            width = 0.95,
            height = 0.85,
            prompt_position = "top",
            preview_cutoff = 120,
            horizontal = {
              preview_width = function(_, cols, _)
                if cols > 200 then
                  return math.floor(cols * 0.4)
                else
                  return math.floor(cols * 0.6)
                end
              end,
            },
            vertical = { width = 0.9, height = 0.95, preview_height = 0.5 },
            flex = { horizontal = { preview_width = 0.9 } },

          },
        },
        extensions = {
          aerial = {
            -- Display symbols as <root>.<parent>.<symbol>
            show_nesting = {
              ["_"] = false, -- This key will be the default
              json = true,   -- You can set the option for specific filetypes
              yaml = true,
            },
          },
          fzf = settings.telescope_fzf_opts,
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({
              previewer        = false,
              initial_mode     = "normal",
              sorting_strategy = 'ascending',
              layout_strategy  = 'horizontal',
              layout_config    = {
                horizontal = {
                  width = 0.5,
                  height = 0.4,
                  preview_width = 0.6,
                },
              },
            })
          },
          frecency = {
            default_workspace = 'CWD',
            show_scores = true,
            show_unindexed = true,
            disable_devicons = false,
            ignore_patterns = {
              "*.git/*",
              "*/tmp/*",
              "*/lua-language-server/*",
            },
          },
          heading = {
            picker_opts = {
              layout_config = { width = 0.8, preview_width = 0.5 },
              layout_strategy = 'horizontal',
            },
          },
          project = {
            theme = "dropdown",
            order_by = "asc",
            search_by = "title",
            sync_with_nvim_tree = false, -- default false
            -- default for on_project_selected = find project files
            on_project_selected = function(prompt_bufnr)
              -- Do anything you want in here. For example:
              project_actions.change_working_directory(prompt_bufnr, false)
              require("harpoon.ui").nav_file(1)
            end
          }
        },
        file_browser = telescope_local_config.file_browser_opts,
        file_ignore_patterns = settings.telescope_file_ignore_patterns,
        pickers = {
          buffers = {
            mappings = {
              i = {
                ["<c-d>"] = actions.delete_buffer,
              },
              n = {
                ["<c-d>"] = actions.delete_buffer,
              },
            },
            previewer = false,
            initial_mode = "insert",
            theme = "dropdown",
            layout_config = {
              width = 0.5,
              height = 0.4,
              prompt_position = "top",
              preview_cutoff = 120,
            },
          },
          current_buffer_fuzzy_find = {
            previewer = true,
            -- theme = "dropdown",
            layout_config = {
              -- width = 0.5,
              height = 0.8,
              prompt_position = "top",
              preview_cutoff = 120,
            },
          },
          find_files = {
            -- theme = "dropdown",
            previewer = true,
            layout_config = {
              -- width = 0.5,
              height = 0.8,
              prompt_position = "top",
              preview_cutoff = 120,
            },
          },
          grep_string = {
            only_sort_text = true,
            previewer = true,
            layout_config = {
              horizontal = {
                width = 0.9,
                height = 0.75,
                preview_width = 0.6,
              },
            },
          },
          git_files = {
            previewer = true,
            layout_config = {
              height = 0.8,
              prompt_position = "top",
              preview_cutoff = 120,
            },
          },
          live_grep = {
            only_sort_text = true,
            previewer = true,
            layout_config = {
              horizontal = {
                width = 0.9,
                height = 0.75,
                preview_width = 0.6,
              },
            },
          },
          lsp_references = {
            show_line = false,
            previewer = true,
            layout_config = {
              horizontal = {
                width = 0.9,
                height = 0.75,
                preview_width = 0.6,
              },
            },
          },
          oldfiles = {
            cwd_only = true,
          },
          treesitter = {
            show_line = false,
            previewer = true,
            layout_config = {
              horizontal = {
                width = 0.9,
                height = 0.75,
                preview_width = 0.6,
              },
            },
          },
        },
        -- UI
        entry_prefix = "  ",
        initial_mode = "insert",
        prompt_prefix = table.concat({ icons.arrows.ChevronRight, " " }),
        border = {},
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        color_devicons = true,

        layout_strategy = "vertical",
        scroll_strategy = "cycle",
        selection_caret = icons.arrows.CurvedArrowRight,
        selection_strategy = "reset",
        sorting_strategy = "descending",
        set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
        use_less = true,
      }

      telescope.load_extension('frecency')
      telescope.load_extension('fzf')
      telescope.load_extension('heading')
      -- telescope.load_extension('make')
      telescope.load_extension('project')
      telescope.load_extension('refactoring')
      telescope.load_extension('ui-select')
      telescope.load_extension('zoxide')
      telescope.load_extension("file_browser")
    end
  },
}
