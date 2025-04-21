return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy", -- Carga el plugin muy pronto, después de VimEnter
        config = function()
            -- Opciones de Vim relacionadas con el tiempo de espera para los mapeos
            vim.o.timeout = true
            vim.o.timeoutlen = 300 -- Tiempo en milisegundos para esperar la siguiente tecla

            -- Configuración de which-key
            require("which-key").setup({
                -- Puedes añadir tu configuración personalizada de which-key aquí dentro {}
                -- o dejarlo vacío {} para usar la configuración por defecto.
                -- Ejemplo:
                -- plugins = { spelling = true },
                -- window = { border = "single" },
            })
        end,
    },
}
