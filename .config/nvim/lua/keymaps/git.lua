--Git lua
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<leader>gl', ':Git log<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gc', ':Git commit<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>ga', ':Git add %<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gs', ':Git status<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gps', ':Git push<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gpl', ':Git pull<CR>', opts)

