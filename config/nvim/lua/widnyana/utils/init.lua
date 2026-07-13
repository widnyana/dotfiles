-- adapted from: https://github.com/ueaner/nvimrc/blob/main/lua/util/init.lua

---@class util
---@field config Config
local M = {}


---@generic T
---@param list T[]
---@return T[]
function M.dedup(list)
  local ret = {}
  local seen = {}
  for _, v in ipairs(list) do
    if not seen[v] then
      table.insert(ret, v)
      seen[v] = true
    end
  end
  return ret
end

return M
