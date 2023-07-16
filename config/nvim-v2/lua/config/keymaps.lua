local keymap = require('utils').keymap


-- Remap command key
keymap("n", "<leader><leader>", ":")
keymap("n", "<C-p>", ":")


-- buffer navigation
keymap('n', '<leader>bp', ':bprev<cr>', { desc = 'Prev buffer' })
keymap('n', '<leader>bn', ':bnext<cr>', { desc = 'Next buffer' })
keymap('n', '<leader>bd', ':bdelete<cr>', { desc = 'Delete buffer' })

-- tab navigation
keymap('n', '<leader>tp', ':tabprevious<cr>', { desc = 'Prev tab' })
keymap('n', '<leader>tn', ':tabnext<cr>', { desc = 'Next tab' })
keymap('n', '<leader>td', ':tabclose<cr>', { desc = 'Close tab' })

-- plugin management
keymap('n', '<leader>pc', ':Lazy check<cr>', { desc = 'Check plugins' })
keymap('n', '<leader>pu', ':Lazy update<cr>', { desc = 'Update plugins' })
keymap('n', '<leader>ps', ':Lazy show<cr>', { desc = 'Show plugins' })
keymap('n', '<leader>ph', ':Lazy help<cr>', { desc = 'Help' })
keymap('n', '<leader>pp', ':Lazy profile<cr>', { desc = 'Profile' })
keymap('n', '<leader>pl', ':Lazy logs<cr>', { desc = 'Logs' })
keymap('n', '<leader>px', ':Lazy clear<cr>', { desc = 'Clear uninstalled plugins' })
keymap('n', '<leader>pr', ':Lazy restore<cr>', { desc = 'Restore plugins from lockfile' })


-- Nvim-Tree
vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<cr>', { silent = true, noremap = true })
local nvtree_api = require("nvim-tree.api")
vim.keymap.set("n", "h", nvtree_api.tree.close)
vim.keymap.set("n", "H", nvtree_api.tree.collapse_all)
