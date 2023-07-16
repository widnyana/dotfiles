local utils = require("utils")

-- Remap command key
vim.keymap.set("n", "<leader><leader>", ":")
vim.keymap.set("n", "<C-p>", ":")



-- Nvim-Tree
vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<cr>', { silent = true, noremap = true })
local nvtree_api = require("nvim-tree.api")
vim.keymap.set("n", "h", nvtree_api.tree.close)
vim.keymap.set("n", "H", nvtree_api.tree.collapse_all)
