-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Increment/Decrement numbers
keymap.set("n", "+", "<C-a>", opts)
keymap.set("n", "-", "<C-x>", opts)

-- Delete one word backward
keymap.set("n", "dw", "vb_d", opts)

-- Select All
keymap.set("n", "<C-a>", "gg<S-v>G", opts)

-- Disable continuations
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- Jumplist
keymap.set("n", "<C-m>", "<C-i>", opts)

-- New tab
keymap.set("n", "te", ":tabedit", opts)

-- Split Window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)
-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Diagnostic
keymap.set("n", "<C-j>", function()
  vim.diagnostic.goto_next()
end, opts)

-- Spell: accept visually selected word into cspell.json (project or global)
local function get_visual_selection()
  local s, e = vim.fn.getpos("'<"), vim.fn.getpos("'>")
  local lines = vim.fn.getline(s[2], e[2])
  if #lines == 0 then
    return ""
  end
  lines[#lines] = string.sub(lines[#lines], 1, e[3])
  lines[1] = string.sub(lines[1], s[3])
  return table.concat(lines, " ")
end

-- global cspell.json (~/.cspell.json) is picked up automatically by cspell's
-- upward directory walk for any project with no closer config of its own;
-- a project cspell.json shadows it, so new project files import it explicitly
local function add_word_to_cspell(path, word, defaults)
  local data = vim.tbl_extend("force", { version = "0.2", words = {} }, defaults or {})
  local f = io.open(path, "r")
  if f then
    local ok, decoded = pcall(vim.json.decode, f:read("*a"))
    f:close()
    if ok and decoded.words then
      data = decoded
    end
  end

  if vim.tbl_contains(data.words, word) then
    vim.notify(('"%s" already in %s'):format(word, path), vim.log.levels.INFO)
    return
  end

  table.insert(data.words, word)
  table.sort(data.words)

  local out = assert(io.open(path, "w"))
  out:write(vim.json.encode(data))
  out:close()

  vim.notify(('Added "%s" to %s'):format(word, path), vim.log.levels.INFO)
  pcall(function()
    require("lint").try_lint()
  end)
end

keymap.set("v", "<Leader>zg", function()
  local word = get_visual_selection()
  if word == "" then
    return
  end

  local project_root = vim.fs.root(0, "cspell.json") or vim.fs.root(0, ".git") or vim.fn.getcwd()
  local project_path = project_root .. "/cspell.json"
  local global_path = vim.fn.expand("~/.cspell.json")

  vim.ui.select({ "project", "global" }, {
    prompt = ('Add "%s" to:'):format(word),
    format_item = function(choice)
      return choice == "project" and ("project (" .. project_path .. ")") or ("global (" .. global_path .. ")")
    end,
  }, function(choice)
    if choice == "project" then
      add_word_to_cspell(project_path, word, { import = { "~/.cspell.json" } })
    elseif choice == "global" then
      add_word_to_cspell(global_path, word)
    end
  end)
end, opts)
