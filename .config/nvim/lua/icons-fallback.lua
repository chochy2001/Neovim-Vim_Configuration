-- Configuración de iconos fallback para terminales sin Nerd Font
local M = {}

function M.setup_fallback_icons()
    local web_devicons = require("nvim-web-devicons")

    -- Usar iconos ASCII simples como fallback
    web_devicons.setup({
        override = {
            md = { icon = "M", color = "#519aba", name = "Md" },
            yaml = { icon = "Y", color = "#fbc02d", name = "Yaml" },
            yml = { icon = "Y", color = "#fbc02d", name = "Yml" },
            json = { icon = "J", color = "#cbcb41", name = "Json" },
            dart = { icon = "D", color = "#03589C", name = "Dart" },
            sh = { icon = "S", color = "#4d5a5e", name = "Sh" },
            log = { icon = "L", color = "#81c784", name = "Log" },
            txt = { icon = "T", color = "#89e051", name = "Txt" },
        },
        default = true,
    })

    print("📄 Iconos fallback ASCII configurados")
end

return M
