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

            vim.notify = function(msg, level, opts)
                -- First run through our error suppression logic
                if type(original_notify) == "function" then
                    -- If original_notify doesn't display (returns early), respect that
                    local should_suppress = false
                    if type(msg) == "string" then
                        local error_patterns = {
                            "E5248.*Invalid character in group name",
                            "BufWinLeave Autocommands",
                            "BufModifiedSet Autocommands",
                            "nvim_exec2.*Error executing lua callback",
                            "attempt to index field 'cmd'",
                            "Error opening file.*vim/_editor%.lua"
                        }
                        for _, pattern in ipairs(error_patterns) do
                            if msg:find(pattern) then
                                should_suppress = true
                                break
                            end
                        end
                    end

                    if should_suppress then
                        return -- Suppress this message completely
                    end
                end

                -- If not suppressed, use the fancy notify plugin
                return notify_plugin(msg, level, opts)
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
