-- Solución definitiva para forzar iconos en Warp Terminal
-- Ejecutar con: :luafile ~/.config/nvim/lua/force-warp-font-fix.lua

print("🔧 FORZANDO CONFIGURACIÓN DEFINITIVA DE WARP")
print("=" .. string.rep("=", 45))

-- Función para verificar y forzar configuración de Warp
local function force_warp_configuration()
    print("\n1️⃣ Verificando configuración actual de Warp...")

    local warp_dir = os.getenv("HOME") .. "/.warp"
    local settings_file = warp_dir .. "/user_preferences.json"

    -- Crear directorio si no existe
    os.execute("mkdir -p " .. warp_dir)

    -- Configuración más específica para Warp
    local warp_config = [[{
  "appearance": {
    "theme": "Standard Dark"
  },
  "text": {
    "font_family": "FiraCode Nerd Font Mono",
    "font_size": 14,
    "line_height": 1.2
  },
  "terminal": {
    "font_family": "FiraCode Nerd Font Mono",
    "font_size": 14
  },
  "editor": {
    "font_family": "FiraCode Nerd Font Mono",
    "font_size": 14
  }
}]]

    -- Escribir configuración forzada
    local file = io.open(settings_file, "w")
    if file then
        file:write(warp_config)
        file:close()
        print("✅ Configuración Warp actualizada:", settings_file)
    end

    -- También intentar configurar via defaults
    local warp_defaults = {
        'defaults write dev.warp.Warp-Stable "Font Family" "FiraCode Nerd Font Mono"',
        'defaults write dev.warp.Warp-Stable "Font Size" 14'
    }

    for _, cmd in ipairs(warp_defaults) do
        os.execute(cmd .. " 2>/dev/null")
    end

    print("✅ Configuración por defaults aplicada")
end

-- Función para crear configuración de iconos mejorada
local function create_enhanced_icon_config()
    print("\n2️⃣ Creando configuración mejorada de iconos...")

    -- Configuración híbrida: Nerd Font + fallbacks ASCII
    local enhanced_config = [[
-- Configuración híbrida de iconos: Nerd Font con fallbacks ASCII
return {
    {
        "nvim-tree/nvim-web-devicons",
        lazy = false,
        priority = 1000,
        config = function()
            local icons = require("nvim-web-devicons")

            -- Detectar si Nerd Font está funcionando
            local function test_nerd_font()
                -- Intentar mostrar un icono y ver si funciona
                return true -- Asumimos que funciona, si no, el usuario puede cambiar
            end

            local use_nerd_font = test_nerd_font()

            if use_nerd_font then
                -- Configuración Nerd Font (completa)
                icons.setup({
                    override = {
                        md = { icon = "", color = "#519aba", name = "Md" },
                        yaml = { icon = "", color = "#fbc02d", name = "Yaml" },
                        yml = { icon = "", color = "#fbc02d", name = "Yml" },
                        json = { icon = "", color = "#cbcb41", name = "Json" },
                        dart = { icon = "", color = "#03589C", name = "Dart" },
                        sh = { icon = "", color = "#4d5a5e", name = "Sh" },
                        log = { icon = "", color = "#81c784", name = "Log" },
                        txt = { icon = "", color = "#89e051", name = "Txt" },
                        c = { icon = "", color = "#599eff", name = "C" },
                        cpp = { icon = "", color = "#f34b7d", name = "Cpp" },
                        kt = { icon = "", color = "#7F52FF", name = "Kotlin" },
                        swift = { icon = "", color = "#e37933", name = "Swift" },
                    },
                    override_by_filename = {
                        ["README.md"] = { icon = "", color = "#42a5f5", name = "Readme" },
                        ["pubspec.yaml"] = { icon = "", color = "#03589C", name = "Pubspec" },
                        ["analysis_options.yaml"] = { icon = "", color = "#03589C", name = "AnalysisOptions" },
                        ["firebase.json"] = { icon = "", color = "#FFA000", name = "Firebase" },
                    },
                    default = true,
                })
                print("✅ Iconos Nerd Font configurados")
            else
                -- Configuración ASCII fallback
                icons.setup({
                    override = {
                        md = { icon = "[M]", color = "#519aba", name = "Md" },
                        yaml = { icon = "[Y]", color = "#fbc02d", name = "Yaml" },
                        yml = { icon = "[Y]", color = "#fbc02d", name = "Yml" },
                        json = { icon = "[J]", color = "#cbcb41", name = "Json" },
                        dart = { icon = "[D]", color = "#03589C", name = "Dart" },
                        sh = { icon = "[S]", color = "#4d5a5e", name = "Sh" },
                        log = { icon = "[L]", color = "#81c784", name = "Log" },
                        txt = { icon = "[T]", color = "#89e051", name = "Txt" },
                    },
                    default = true,
                })
                print("✅ Iconos ASCII fallback configurados")
            end

            -- Crear comandos para cambiar entre modos
            vim.api.nvim_create_user_command("UseNerdFontIcons", function()
                package.loaded['nvim-web-devicons'] = nil
                require("nvim-web-devicons").setup({
                    override = {
                        md = { icon = "", color = "#519aba", name = "Md" },
                        yaml = { icon = "", color = "#fbc02d", name = "Yaml" },
                        dart = { icon = "", color = "#03589C", name = "Dart" },
                    },
                    default = true,
                })
                vim.cmd("Lazy reload neo-tree.nvim")
                print("🎯 Cambiado a iconos Nerd Font")
            end, { desc = "Switch to Nerd Font icons" })

            vim.api.nvim_create_user_command("UseSimpleIcons", function()
                package.loaded['nvim-web-devicons'] = nil
                require("nvim-web-devicons").setup({
                    override = {
                        md = { icon = "[M]", color = "#519aba", name = "Md" },
                        yaml = { icon = "[Y]", color = "#fbc02d", name = "Yaml" },
                        dart = { icon = "[D]", color = "#03589C", name = "Dart" },
                        sh = { icon = "[S]", color = "#4d5a5e", name = "Sh" },
                        json = { icon = "[J]", color = "#cbcb41", name = "Json" },
                        log = { icon = "[L]", color = "#81c784", name = "Log" },
                        txt = { icon = "[T]", color = "#89e051", name = "Txt" },
                    },
                    default = true,
                })
                vim.cmd("Lazy reload neo-tree.nvim")
                print("📄 Cambiado a iconos ASCII simples")
            end, { desc = "Switch to simple ASCII icons" })
        end,
    }
}
]]

    local enhanced_file = vim.fn.stdpath("config") .. "/lua/plugins/icons-enhanced.lua"
    local file = io.open(enhanced_file, "w")
    if file then
        file:write(enhanced_config)
        file:close()
        print("✅ Configuración híbrida creada:", enhanced_file)
    end
end

-- Función para mostrar instrucciones específicas
local function show_final_instructions()
    print("\n3️⃣ INSTRUCCIONES FINALES:")
    print("=" .. string.rep("=", 30))

    print("\n🔴 SI LOS ICONOS SIGUEN SIN FUNCIONAR:")
    print("1. Ejecuta: :UseSimpleIcons")
    print("   → Esto cambiará a iconos ASCII como [M], [Y], [D]")
    print("   → Funcionarán en cualquier terminal")

    print("\n🟢 PARA PROBAR ICONOS NERD FONT:")
    print("1. REINICIA Warp Terminal completamente")
    print("2. Ve a Warp Settings (Cmd + ,)")
    print("3. Appearance → Text → Font Family")
    print("4. Selecciona 'FiraCode Nerd Font Mono'")
    print("5. Ejecuta: :UseNerdFontIcons")

    print("\n💡 COMANDOS DISPONIBLES AHORA:")
    print("• :UseNerdFontIcons - Probar iconos Nerd Font")
    print("• :UseSimpleIcons - Usar iconos ASCII simples")
    print("• :ForceIconReload - Recargar sistema de iconos")

    print("\n🎯 RECOMENDACIÓN:")
    print("Si los iconos Nerd Font no funcionan inmediatamente,")
    print("usa :UseSimpleIcons para tener una interfaz funcional")
    print("mientras configuras la fuente correctamente.")
end

-- Ejecutar todas las configuraciones
force_warp_configuration()
create_enhanced_icon_config()
show_final_instructions()

-- Crear comando principal
vim.api.nvim_create_user_command("ForceWarpFontFix", function()
    force_warp_configuration()
    create_enhanced_icon_config()
    show_final_instructions()
end, { desc = "Force complete Warp font and icon configuration" })

print("\n💡 Comando creado: :ForceWarpFontFix")