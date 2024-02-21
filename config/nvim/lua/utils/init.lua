local M = {}

-- functions


function M.merge(...)
    return vim.tbl_deep_extend('force', ...)
end


function M.keymap(mode, lhs, rhs, opts)
    local defaults = {
        silent = true,
        noremap = true,
    }
    vim.keymap.set(mode, lhs, rhs, M.merge(defaults, opts or {}))
end


return M