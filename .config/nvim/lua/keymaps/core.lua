--Core Lua atajos
local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('i', 'jj', '<Esc>', opts)
vim.api.nvim_set_keymap('n', '<leader><CR>', ':luafile ~/.config/nvim/init.lua<CR>', opts)
vim.keymap.set("n", "<leader>ot", ":TagbarToggle<CR>", { noremap = true, silent = true, desc = "Toggle Tagbar" })


