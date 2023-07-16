local M = {}

-- functions
function M.create_buf_map(bufnr, opts)
    return function(mode, lhs, rhs, map_opts)
      M.keymap(
        mode,
        lhs,
        rhs,
        M.merge({
          buffer = bufnr,
        }, opts or {}, map_opts or {})
      )
    end
  end
  
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

function M.on_attach(on_attach)
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local buffer = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            on_attach(client, buffer)
        end,
    })
end

function M.warn(msg, notify_opts)
    vim.notify(msg, vim.log.levels.WARN, notify_opts)
end

function M.error(msg, notify_opts)
    vim.notify(msg, vim.log.levels.ERROR, notify_opts)
end

function M.info(msg, notify_opts)
    vim.notify(msg, vim.log.levels.INFO, notify_opts)
end

---@param silent boolean?
---@param values? {[1]:any, [2]:any}
function M.toggle(option, silent, values)
    if values then
        if vim.opt_local[option]:get() == values[1] then
            vim.opt_local[option] = values[2]
        else
            vim.opt_local[option] = values[1]
        end
        return require("utils").info("Set " .. option .. " to " .. vim.opt_local[option]:get(), { title = "Option" })
    end
    vim.opt_local[option] = not vim.opt_local[option]:get()
    if not silent then
        if vim.opt_local[option]:get() then
            require("utils").info("Enabled " .. option, { title = "Option" })
        else
            require("utils").warn("Disabled " .. option, { title = "Option" })
        end
    end
end

return M
