local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
-- Ir a la definicion
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)

-- Ir a la declaración
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)

-- Ver implementación
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)

-- Ver referencias (donde se usa la variable/función)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

-- Mostrar información flotante de documentación
vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

-- Mostrar la firma de función en insert mode
vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)

-- Renombrar símbolo
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)

-- Aplicar código de acción (como fix quick)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

-- Formatear archivo actual
vim.keymap.set('n', '<leader>f', function()
    vim.lsp.buf.format { async = true }
end, opts)

-- Ir a la definición de tipo
vim.keymap.set('n', '<leader>b', '<C-o>', { noremap = true })
vim.keymap.set('n', '<leader>f', '<C-i>', { noremap = true })

