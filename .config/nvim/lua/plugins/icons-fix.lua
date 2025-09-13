-- Configuración ULTRA MÍNIMA - SIN errores E5248 garantizado
return {
    {
        "nvim-tree/nvim-web-devicons",
        lazy = false,
        priority = 1000,
        config = function()
            -- Configuración MÍNIMA - solo usa iconos por defecto del plugin
            require("nvim-web-devicons").setup({
                default = true,
                color_icons = true,
                strict = false,
                -- NO overrides - usar SOLO lo que viene por defecto
            })

            print("✅ Configuración MÍNIMA de iconos - SIN overrides que causen E5248")
        end,
    },
}