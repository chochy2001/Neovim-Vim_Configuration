local opts = { noremap = true, silent = true }

-- Navegación de jump list
vim.keymap.set("n", "<leader>b", "<C-o>", opts) -- atrás
vim.keymap.set("n", "<leader>f", "<C-i>", opts) -- adelante
