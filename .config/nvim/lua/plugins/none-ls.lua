-- Archivo: lua/plugins/none-ls.lua
return {
    "nvimtools/none-ls.nvim",
    config = function()
        local null_ls = require("null-ls")
        null_ls.setup({
            -- Añade un retraso (ej. 250ms) antes de ejecutar fuentes tras un cambio
            debounce = 250, -- Puedes ajustar este valor

            sources = {
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.formatting.prettier,
                null_ls.builtins.diagnostics.erb_lint,
                null_ls.builtins.diagnostics.rubocop,
                null_ls.builtins.formatting.rubocop,
            },
        })

        vim.keymap.set("n", "<leader>ff", vim.lsp.buf.format, {})
    end,
}
