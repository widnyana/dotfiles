local api = vim.api

local colors = {
    fg = "#76787d",
    bg = "#252829",
}

-- don't auto comment new line
api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

-- go to last loc when opening a buffer
api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- silent exit on manpages
api.nvim_create_autocmd("FileType", { pattern = "man", command = [[nnoremap <buffer><silent> q :quit<CR>]] })

-- do wrap and dont spellcheck on gitcommit and markdown files 
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "gitcommit", "markdown" },
    callback = function()
            vim.opt_local.wrap = true
            vim.opt_local.spell = false
    end,
})

-- show cursor line only in active window
local cursorGrp = api.nvim_create_augroup("CursorLine", { clear = true })
api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
    pattern = "*",
    command = "set cursorline",
    group = cursorGrp,
})
api.nvim_create_autocmd(
    { "InsertEnter", "WinLeave" },
    { pattern = "*", command = "set nocursorline", group = cursorGrp }
)


vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function()
        -- change the background color of floating windows and borders.
        vim.cmd('highlight NormalFloat guibg=none guifg=none')
        vim.cmd('highlight FloatBorder guifg=' .. colors.fg .. ' guibg=none')
        vim.cmd('highlight NormalNC guibg=none guifg=none')
    end,
})
