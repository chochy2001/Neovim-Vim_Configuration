--plugins lua
local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', '<leader>pi', ':PackerInstall<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>pc', ':PackerClean<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>ps', ':PackerSync<CR>', opts)


