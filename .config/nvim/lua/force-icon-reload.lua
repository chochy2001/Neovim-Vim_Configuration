-- Script para forzar la recarga completa de iconos en Neo-tree
-- Ejecutar con: :luafile ~/.config/nvim/lua/force-icon-reload.lua

print("🔄 FORZANDO RECARGA COMPLETA DE ICONOS")
print("=" .. string.rep("=", 40))

-- Función para recargar todos los sistemas de iconos
local function force_complete_reload()
    print("\n1️⃣ Recargando nvim-web-devicons...")

    -- Limpiar caché de require
    package.loaded['nvim-web-devicons'] = nil
    package.loaded['plugins.icons-complete'] = nil

    -- Recargar nvim-web-devicons
    local ok, web_devicons = pcall(require, "nvim-web-devicons")
    if ok then
        print("✅ nvim-web-devicons recargado")

        -- Configurar iconos manualmente si es necesario
        web_devicons.refresh()

        -- Verificar algunos iconos específicos
        local test_files = {
            "README.md",
            "pubspec.yaml",
            "analysis_options.yaml",
            "firebase.json",
            "main.dart",
            "script.sh"
        }

        print("\n🧪 Probando iconos específicos:")
        for _, file in ipairs(test_files) do
            local icon, color = web_devicons.get_icon(file)
            if icon then
                print(string.format("  %s %s (%s)", icon, file, color or "sin color"))
            else
                print(string.format("  ❌ %s - sin icono", file))
            end
        end
    else
        print("❌ Error recargando nvim-web-devicons:", web_devicons)
    end

    print("\n2️⃣ Recargando Neo-tree...")

    -- Cerrar Neo-tree si está abierto
    pcall(function()
        vim.cmd("Neotree close")
    end)

    -- Limpiar caché de Neo-tree
    package.loaded['neo-tree'] = nil
    package.loaded['plugins.neo-tree'] = nil

    -- Esperar un poco y recargar
    vim.defer_fn(function()
        -- Recargar plugins específicos
        pcall(function()
            vim.cmd("Lazy reload nvim-web-devicons")
        end)

        pcall(function()
            vim.cmd("Lazy reload neo-tree.nvim")
        end)

        print("✅ Neo-tree recargado")

        -- Abrir Neo-tree para probar
        vim.defer_fn(function()
            pcall(function()
                vim.cmd("Neotree filesystem reveal left")
                print("\n🎯 Neo-tree abierto con nuevos iconos")
                print("💡 Verifica que los iconos se vean correctamente")
            end)
        end, 500)
    end, 300)
end

-- Función para verificar configuración de fuente en terminal
local function check_font_config()
    print("\n3️⃣ Verificando configuración de fuente...")

    -- Detectar terminal
    local term = os.getenv("TERM_PROGRAM") or "unknown"
    print("Terminal detectado:", term)

    -- Probar caracteres Nerd Font
    local nerd_chars = {
        { char = "", name = "Folder icon" },
        { char = "", name = "File icon" },
        { char = "", name = "Markdown icon" },
        { char = "", name = "YAML icon" },
        { char = "", name = "JSON icon" },
        { char = "", name = "Dart icon" },
    }

    print("\n🔤 Caracteres Nerd Font de prueba:")
    for _, item in ipairs(nerd_chars) do
        print(string.format("  %s  ← %s", item.char, item.name))
    end

    print("\n💡 Si ves símbolos raros arriba:")
    if term == "WarpTerminal" then
        print("  1. Abre Warp Settings (Cmd + ,)")
        print("  2. Ve a Appearance → Text")
        print("  3. Cambia Font Family a 'FiraCode Nerd Font'")
        print("  4. Aplica y reinicia Warp")
    else
        print("  1. Configura tu terminal para usar 'FiraCode Nerd Font'")
        print("  2. Reinicia el terminal completamente")
    end
end

-- Crear comando permanente
vim.api.nvim_create_user_command("ForceIconReload", function()
    force_complete_reload()
end, { desc = "Force complete reload of all icon systems" })

vim.api.nvim_create_user_command("CheckFontConfig", function()
    check_font_config()
end, { desc = "Check terminal font configuration" })

-- Ejecutar recarga automática
force_complete_reload()
check_font_config()

print("\n🎉 RECARGA COMPLETA FINALIZADA!")
print("\n📋 COMANDOS CREADOS:")
print("• :ForceIconReload - Recargar todos los iconos")
print("• :CheckFontConfig - Verificar configuración de fuente")