-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  command = "set nopaste",
})

-- Disable the concealing in some file formats
-- the default conceallevel is 3 in LazyVim
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc", "markdown" },
  callback = function()
    vim.opt.conceallevel = 0
  end,
})

-- ── Error logging ──────────────────────────────────────────────────────
-- All errors/warnings are appended to stdpath("state")/messages.log so they
-- survive after the on-screen notification is dismissed. Read with
--   :messages            (in-session)
--   tail ~/.local/state/nvim/messages.log
-- Note: errors that occur BEFORE config loads (early startup) can't be caught
-- here — for those, export NVIM_LOG_FILE in your shell (see README/notes).
local log_path = vim.fn.stdpath("state") .. "/messages.log"
local function level_name(level)
  for name, val in pairs(vim.log.levels) do
    if val == level then
      return name
    end
  end
  return tostring(level)
end
local max_log_bytes = 5 * 1024 * 1024 -- 5 MiB safety cap: a misbehaving plugin that
-- spams vim.notify (e.g. retrying a failed setup) must not be allowed to grow
-- this file unbounded and hammer disk I/O.
local function log_to_file(level_name, msg)
  local stat = (vim.uv or vim.loop).fs_stat(log_path)
  if stat and stat.size > max_log_bytes then
    return
  end
  local f = io.open(log_path, "a")
  if f then
    f:write(string.format("[%s] %s: %s\n", os.date("%Y-%m-%d %H:%M:%S"), level_name, tostring(msg)))
    f:close()
  end
end

-- Plugin notifications route through vim.notify — wrap and delegate.
local orig_notify = vim.notify
vim.notify = function(msg, level, opts)
  log_to_file(level_name(level or vim.log.levels.INFO), msg)
  if orig_notify then
    return orig_notify(msg, level, opts)
  end
end

