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

-- Hop
keymap("n", "<leader>H", "<cmd>HopAnywhere<CR>", { silent = true })
keymap("n", "<leader>h", "<cmd>HopWord<CR>", { silent = true })

-- romgrk/barbar.nvim
-- -- Move to previous/next
keymap('n', '<A-,>', '<Cmd>BufferPrevious<CR>', { silent = true })
keymap('n', '<A-.>', '<Cmd>BufferNext<CR>', { silent = true })
-- -- Re-order to previous/next
keymap('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', { silent = true })
keymap('n', '<A->>', '<Cmd>BufferMoveNext<CR>', { silent = true })
-- -- Goto buffer in position...
keymap('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', { silent = true })
keymap('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', { silent = true })
keymap('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', { silent = true })
keymap('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', { silent = true })
keymap('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', { silent = true })
keymap('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', { silent = true })
keymap('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', { silent = true })
keymap('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', { silent = true })
keymap('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', { silent = true })
keymap('n', '<A-0>', '<Cmd>BufferLast<CR>', { silent = true })
-- -- Pin/unpin buffer
keymap('n', '<A-p>', '<Cmd>BufferPin<CR>', { silent = true })
-- -- Close buffer
keymap('n', '<A-c>', '<Cmd>BufferClose<CR>', { silent = true })


-- Nvim-Tree
keymap('n', '<leader>e', '<cmd>NvimTreeToggle<cr>', { silent = true, noremap = true })
local nvtree_api = require("nvim-tree.api")
keymap("n", "h", nvtree_api.tree.close)
keymap("n", "H", nvtree_api.tree.collapse_all)
