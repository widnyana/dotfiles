local M = {}


M.telescope_git_or_file = function()
    local path = vim.fn.expand("%:p:h")
    local git_dir = vim.fn.finddir(".git", path .. ";")
    if #git_dir > 0 then
        require("telescope.builtin").git_files()
    else
        require("telescope.builtin").find_files()
    end
end

M.toggle_set_color_column = function()
    if vim.wo.colorcolumn == "" then
        vim.wo.colorcolumn = "120"
    else
        vim.wo.colorcolumn = ""
    end
end

M.toggle_cursor_line = function()
    if vim.wo.cursorline then
        vim.wo.cursorline = false
    else
        vim.wo.cursorline = true
    end
end

M.change_background = function()
    if vim.o.background == "dark" then
        vim.o.background = "light"
    else
        vim.o.background = "dark"
    end
end


M.toggle_inlay_hints = function()
    -- h = { "<cmd>lua vim.lsp.inlay_hint(0, true)<cr>", "Enable Inlay Hints" },
    -- H = { "<cmd>lua vim.lsp.inlay_hint(0, false)<cr>", "Disable Inlay Hints" },

    if vim.b.inlay_hints then
        vim.lsp.inlay_hint(0, false)
        vim.b.inlay_hints = false
    else
        vim.lsp.inlay_hint(0, true)
        vim.b.inlay_hints = true
    end
end


return M
