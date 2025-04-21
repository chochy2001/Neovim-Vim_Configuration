-- lua/plugins/treesitter.lua (AÑADIENDO RAINBOW DELIMITERS)
return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "nvim-treesitter/playground",
            "hiphish/rainbow-delimiters.nvim", -- <-- AÑADIDO
        },
        config = function()
            local ts_configs = require("nvim-treesitter.configs")
            ts_configs.setup({
                ensure_installed = {
                    -- tu lista de lenguajes
                },
                sync_install = false,
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
                -- NO necesitas la sección 'rainbow' aquí para rainbow-delimiters
            })

            -- Configuración específica de rainbow-delimiters (OPCIONAL, usa defaults si no pones esto)
            -- Debe hacerse DESPUÉS de cargar Treesitter
            -- Podrías ponerlo en un `vim.defer_fn` o confiar en que se cargue por dependencia
            pcall(require, "rainbow-delimiters.setup") -- Llama al setup del plugin de rainbow
        end,
    },
    -- Ya está listado como dependencia arriba
    -- { "hiphish/rainbow-delimiters.nvim" }
}
