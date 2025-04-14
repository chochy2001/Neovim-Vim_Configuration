local opts = { noremap = true, silent = true }

-- Mostrar la firma de función en insert mode
vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)

-- Renombrar símbolo
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

-- Aplicar código de acción (como quickfix)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

-- Navegación de jump list
vim.keymap.set("n", "<leader>b", "<C-o>", opts) -- atrás
vim.keymap.set("n", "<leader>f", "<C-i>", opts) -- adelante
