--buffers lua
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<leader>bn', ':bn<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>bp', ':bp<CR>', opts)

