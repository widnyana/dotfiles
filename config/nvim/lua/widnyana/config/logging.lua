-- Persistent error/warning log — all vim.notify calls are appended to
-- stdpath("state")/messages.log so they survive after the on-screen
-- notification is dismissed. Read with:
--   :messages            (in-session)
--   tail ~/.local/state/nvim/messages.log
-- setup() is called from init.lua before require("config.lazy"), so this
-- also captures lazy.nvim bootstrap/startup notifications, not just ones
-- fired after the VeryLazy event.
local M = {}

local log_path = vim.fn.stdpath("state") .. "/messages.log"
local max_log_bytes = 5 * 1024 * 1024 -- 5 MiB safety cap: a misbehaving plugin that
-- spams vim.notify (e.g. retrying a failed setup) must not be allowed to grow
-- this file unbounded and hammer disk I/O.

local log_file

local function get_log_file()
  if not log_file then
    log_file = io.open(log_path, "a")
  end
  return log_file
end

local function level_name(level)
  for name, val in pairs(vim.log.levels) do
    if val == level then
      return name
    end
  end
  return tostring(level)
end

local function log_to_file(name, msg)
  local stat = (vim.uv or vim.loop).fs_stat(log_path)
  if stat and stat.size > max_log_bytes then
    return
  end
  local f = get_log_file()
  if f then
    f:write(string.format("[%s] %s: %s\n", os.date("%Y-%m-%d %H:%M:%S"), name, tostring(msg)))
    f:flush()
  end
end

function M.setup()
  local orig_notify = vim.notify
  vim.notify = function(msg, level, opts)
    log_to_file(level_name(level or vim.log.levels.INFO), msg)
    if orig_notify then
      return orig_notify(msg, level, opts)
    end
  end

  vim.api.nvim_create_autocmd("VimLeave", {
    callback = function()
      if log_file then
        log_file:close()
      end
    end,
  })
end

return M
