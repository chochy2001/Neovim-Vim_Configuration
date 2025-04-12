--terminal lua
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<leader>t', ':FloatermToggle<CR>', opts)
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', opts)

