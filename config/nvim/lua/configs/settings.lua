local M = {}

M.bufferline_tab_style = "thin"

M.cody_options = {
  -- Disable LSP suggestions
  on_attach = function(client)
    local buffer_name = vim.fn.expand "%:t"
    if buffer_name ~= "COMMIT_EDITMSG" then
      if client.supports_method "textDocument/formatting" then
        vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format { bufnr = bufnr }
          end,
        })
      end

      if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec(
          [[
        augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
      ]],
          false
        )
      end
    end
  end,
}

M.cody_keys = {

  {
    "<leader>ai",
    ":CodyChat<CR>",
    mode = "n",
    desc = "AI Assistant",
  },

  {
    "<leader>ad",
    function()
      local line = vim.fn.getline "."
      local start = vim.fn.col "."
      local finish = vim.fn.col "$"
      local text = line:sub(start, finish)
      vim.fn.setreg('"', text)
      vim.cmd [[CodyTask 'Write document for current context']]
    end,
    mode = "n",
    desc = "Generate Document with AI",
  },

  {
    "<leader>ac",
    ':CodyTask ""<Left>',
    mode = "n",
    desc = "Let AI Write Code",
  },

  {
    "<leader>aa",
    ":CodyTaskAccept<CR>",
    mode = "n",
    desc = "Confirm AI work",
  },

  {
    "<leader>as",
    "<cmd> lua require('sg.extensions.telescope').fuzzy_search_results()<CR>",
    mode = "n",
    desc = "AI Search",
  },

  {
    "<leader>ai",
    "y:CodyChat<CR><ESC>pG$a<CR>",
    mode = "v",
    desc = "Chat Selected Code",
  },

  -- {
  --   "<leader>ad",
  --   "{:CodyTask 'Write document for current context<CR>'",
  --   mode = "n",
  --   desc = "Generate Document with AI",
  -- },

  {
    "<leader>ar",
    "y:CodyChat<CR>refactor following code:<CR><ESC>p<CR>",
    mode = "v",
    desc = "Request Refactoring",
  },

  {
    "<leader>ae",
    "y:CodyChat<CR>explain following code:<CR><ESC>p<CR>",
    mode = "v",
    desc = "Request Explanation",
  },

  {
    "<leader>af",
    "y:CodyChat<CR>find potential vulnerabilities from following code:<CR><ESC>p<CR>",
    mode = "v",
    desc = "Request Potential Vulnerabilities",
  },

  {
    "<leader>at",
    "y:CodyChat<CR>rewrite following code more idiomatically:<CR><ESC>p<CR>",
    mode = "v",
    desc = "Request Idiomatic Rewrite",
  },
}

-- theme: nightfox, tokyonight, tundra, kanagawa, oxocarbon; default is catppuccin
-- refer to the themes settings file for different styles
M.colorscheme = "oxocarbon"

M.file_explorer_title = "🥷 File Explorer"

-- enable or disable listchars
M.list = false

-- which list chars to schow
M.listchars = "eol:¬,tab:>·,trail:~,extends:>,precedes:<"

-- list of disabled plugins
M.disable_builtin_plugins = {}

-- lsp kinds icons
M.lsp_kinds = {
  Text = " ",
  Method = " ",
  Function = " ",
  Constructor = " ",
  Field = " ",
  Variable = " ",
  Class = " ",
  Interface = " ",
  Module = " ",
  Property = " ",
  Unit = " ",
  Value = " ",
  Enum = " ",
  Keyword = " ",
  Snippet = " ",
  Color = " ",
  File = " ",
  Reference = " ",
  Folder = " ",
  EnumMember = " ",
  Constant = " ",
  Struct = " ",
  Event = " ",
  Operator = " ",
  TypeParameter = " ",
  Copilot = " ",
  Namespace = " ",
  Package = " ",
  String = " ",
  Number = " ",
  Boolean = " ",
  Array = " ",
  Object = " ",
  Key = " ",
  Null = " ",
}


-- Packages that should be installed by Mason
M.mason_packages = {
  -- DAP
  "clangd",
  "codelldb",
  "cspell",
  "debugpy",

  -- Formatter
  'golines',
  "black",
  "clang-format",
  "cueimports",
  "gofumpt",
  "prettier",
  "shfmt",
  "stylua",

  -- Linter
  "editorconfig-checker",
  "eslint_d",
  "markdownlint",
  "pyright",
  "ruff",
  "shellcheck",
  "tflint",
  "yamllint",

  -- Language Server via mason
  "lua-language-server",
  "yaml-language-server",
  "bash-language-server",
  "gopls",
  "json-lsp",
  "marksman",
  "zls" -- zig language server
}

-- stolen from NvChad core.mappings
M.mappings = {
  general = {
    i = {
      -- go to  beginning and end
      ["<C-b>"] = { "<ESC>^i", "Beginning of line" },
      ["<C-e>"] = { "<End>", "End of line" },

      -- navigate within insert mode
      ["<C-h>"] = { "<Left>", "Move left" },
      ["<C-l>"] = { "<Right>", "Move right" },
      ["<C-j>"] = { "<Down>", "Move down" },
      ["<C-k>"] = { "<Up>", "Move up" },
    },

    n = {
      ["<Esc>"] = { ":noh <CR>", "Clear highlights" },
      -- switch between windows
      ["<C-h>"] = { "<C-w>h", "Window left" },
      ["<C-l>"] = { "<C-w>l", "Window right" },
      ["<C-j>"] = { "<C-w>j", "Window down" },
      ["<C-k>"] = { "<C-w>k", "Window up" },

      -- save
      ["<C-s>"] = { "<cmd> w <CR>", "Save file" },

      -- Copy all
      ["<C-c>"] = { "<cmd> %y+ <CR>", "Copy whole file" },

      -- line numbers
      ["<leader>n"] = { "<cmd> set nu! <CR>", "Toggle line number" },
      ["<leader>rn"] = { "<cmd> set rnu! <CR>", "Toggle relative number" },

      -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
      -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
      -- empty mode is same as using <cmd> :map
      -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
      ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },
      ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
      ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
      ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },

      -- new buffer
      ["<leader>b"] = { "<cmd> enew <CR>", "New buffer" },
      ["<leader>ch"] = { "<cmd> NvCheatsheet <CR>", "Mapping cheatsheet" },

      ["<leader>fm"] = {
        function()
          vim.lsp.buf.format { async = true }
        end,
        "LSP formatting",
      },
    },
  }
}
-- which patterns to ignore in file switcher
M.telescope_file_ignore_patterns = {
  "%.7z",
  "%.JPEG",
  "%.JPG",
  "%.MOV",
  "%.RAF",
  "%.burp",
  "%.bz2",
  "%.cache",
  "%.class",
  "%.dll",
  "%.docx",
  "%.dylib",
  "%.epub",
  "%.exe",
  "%.flac",
  "%.ico",
  "%.ipynb",
  "%.jar",
  "%.jpeg",
  "%.jpg",
  "%.lock",
  "%.mkv",
  "%.mov",
  "%.mp4",
  "%.otf",
  "%.pdb",
  "%.pdf",
  "%.png",
  "%.rar",
  "%.sqlite3",
  "%.svg",
  "%.tar",
  "%.tar.gz",
  "%.ttf",
  "%.webp",
  "%.zip",
  ".git/",
  ".gradle/",
  ".idea/",
  ".settings/",
  ".vale/",
  ".vscode/",
  "__pycache__/*",
  "build/",
  "env/",
  "gradle/",
  "node_modules/",
  "smalljre_*/*",
  "target/",
  "vendor/*",
}

-- set relative numbered lines
M.relative_number = false

-- always show tabs; 0 never, 1 only if at least two tab pages, 2 always
M.showtabline = 1

-- options for fzf in telescope
M.telescope_fzf_opts = {
  fuzzy = true,                   -- false will only do exact matching
  override_generic_sorter = true, -- override the generic sorter
  override_file_sorter = true,    -- override the file sorter
  case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
}

-- enable greping in hidden files
M.telescope_grep_hidden = false

-- A list of parser names, or "all"
-- this five listed parsers should always be installed: "c", "lua", "vim", "vimdoc", "query"
M.treesitter_ensure_installed = {
  --  this five listed parsers should always be installed: "c", "lua", "vim", "vimdoc", "query"
  "c",
  "lua",
  "vim",
  "vimdoc",
  "query",
  -- add another below
  "comment",
  "gitignore",
  "gomod",
  "gowork",
  "go",
  "json",
  "markdown",
  "python",
  "rust",
  "yaml",

  "zig"
}

-- List of parsers to ignore installing (or "all")
M.treesitter_ignore_install = {}

return M
