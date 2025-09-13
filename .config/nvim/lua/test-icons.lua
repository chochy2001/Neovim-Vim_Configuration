-- Script para probar iconos después de configurar Nerd Font
-- Ejecutar con: :luafile ~/.config/nvim/lua/test-icons.lua

print("🧪 PROBANDO ICONOS NERD FONT")
print("=" .. string.rep("=", 30))

-- Función para probar iconos específicos
local function test_icon_display()
    local icons_to_test = {
        -- Iconos básicos
        { icon = "", name = "Folder" },
        { icon = "", name = "File" },
        { icon = "", name = "Git" },
        { icon = "", name = "Terminal" },

        -- Iconos de lenguajes
        { icon = "", name = "Dart/Flutter" },
        { icon = "", name = "Swift" },
        { icon = "", name = "C" },
        { icon = "", name = "Kotlin" },
        { icon = "", name = "JavaScript" },
        { icon = "", name = "JSON" },

        -- Iconos de archivos especiales
        { icon = "", name = "Config" },
        { icon = "", name = "Package" },
        { icon = "", name = "Lock file" },
        { icon = "", name = "README" },
    }

    print("\n📋 Iconos de prueba:")
    for _, item in ipairs(icons_to_test) do
        print(string.format("  %s  %s", item.icon, item.name))
    end

    print("\n💡 Si ves símbolos raros o '?' en lugar de iconos:")
    print("  1. Verifica que configuraste 'FiraCode Nerd Font' en Warp")
    print("  2. Reinicia Warp Terminal completamente")
    print("  3. Ejecuta :ReloadIconsComplete en Neovim")
end

-- Función para verificar el estado de nvim-web-devicons
local function check_webdev_icons()
    local ok, webdev = pcall(require, "nvim-web-devicons")
    if ok then
        print("\n✅ nvim-web-devicons cargado correctamente")

        -- Probar algunos iconos específicos
        local test_files = {
            "main.dart",
            "AppDelegate.swift",
            "main.c",
            "MainActivity.kt",
            "package.json",
            "pubspec.yaml"
        }

        print("\n🔍 Iconos por tipo de archivo:")
        for _, filename in ipairs(test_files) do
            local icon, color = webdev.get_icon(filename, nil, { default = true })
            print(string.format("  %s  %s (%s)", icon or "?", filename, color or "sin color"))
        end
    else
        print("\n❌ Error cargando nvim-web-devicons:", webdev)
    end
end

-- Ejecutar pruebas
test_icon_display()
check_webdev_icons()

print("\n🚀 PRUEBA COMPLETA!")
print("\n📌 SIGUIENTE PASO:")
print("   Abre Neo-tree con <leader>pv para ver los iconos en acción")

-- Crear comando permanente
vim.api.nvim_create_user_command("TestIconsComplete", function()
    test_icon_display()
    check_webdev_icons()
end, { desc = "Test all icon configurations" })

print("\n💡 Comando creado: :TestIconsComplete")