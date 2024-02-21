-- References to ./lua/
if vim.fn.has('nvim-0.9') == 0 then
    error('Need Neovim v0.9+ in order to use this configs')
end

require("configs.options")
require("configs.autocmds")
require("configs.lazy")

-- post
require("post-initialization")