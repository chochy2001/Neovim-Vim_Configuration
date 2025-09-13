-- lua/plugins/ui.lua
return {
    -- Notificaciones mejoradas
    {
        "rcarriga/nvim-notify",
        event = "VeryLazy",
        config = function()
            -- Preserve existing vim.notify wrapper (from error-suppressor.lua)
            local original_notify = vim.notify
            local notify_plugin = require("notify")

            -- Simplified approach: preserve the filtering chain
            vim.notify = function(msg, level, opts)
                -- Save the current vim.notify (which will be this function)
                local current_notify = vim.notify

                -- Temporarily replace vim.notify with our fancy notify plugin
                -- This is what will get called if the message passes all filters
                vim.notify = notify_plugin

                -- Call the original wrapper chain
                -- If it returns early (suppressed), notify_plugin won't be called
                -- If it passes through, notify_plugin will be called instead of the original
                local result = original_notify(msg, level, opts)

                -- Restore our wrapper function
                vim.notify = current_notify

                return result
            end
        end,
    },
    -- Reemplaza vim.ui.input y vim.ui.select
    { "stevearc/dressing.nvim", event = "VeryLazy" },
    -- Iconos (usados por lualine, trouble, etc.)
    { "echasnovski/mini.icons", event = "VeryLazy" },
    -- Cursor suave (efecto visual)
    {
        "gen740/SmoothCursor.nvim",
        event = "VeryLazy",
        config = function()
            require("smoothcursor").setup()
        end,
    },
    -- Líneas de indentación visuales
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl", -- Nombre principal del módulo
        event = "VeryLazy", -- O "BufReadPre" si quieres que aparezcan inmediatamente
        opts = {},    -- Usa opts para configuración simple o config = function() para compleja
        -- config = function()
        --   require("ibl").setup() -- Puedes poner config más detallada aquí
        -- end
    },
}
