local M = {}

-- theme: nightfox, tokyonight, tundra, kanagawa, oxocarbon; default is catppuccin
-- refer to the themes settings file for different styles
M.colorscheme = "oxocarbon"

-- set relative numbered lines
M.relative_number = false

-- always show tabs; 0 never, 1 only if at least two tab pages, 2 always
M.showtabline = 1

-- enable or disable listchars
M.list = false

-- which list chars to schow
M.listchars = "eol:¬,tab:>·,trail:~,extends:>,precedes:<"

-- list of disabled plugins
M.disable_builtin_plugins = {}

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

-- options for fzf in telescope 
M.telescope_fzf_opts = {
  fuzzy = true,                   -- false will only do exact matching
  override_generic_sorter = true, -- override the generic sorter
  override_file_sorter = true,    -- override the file sorter
  case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
}

-- enable greping in hidden files
M.telescope_grep_hidden = false


return M
