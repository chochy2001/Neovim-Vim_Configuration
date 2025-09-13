-- Script para configurar automáticamente Warp Terminal con Nerd Font
-- Ejecutar con: :luafile ~/.config/nvim/lua/configure-warp-font.lua

print("🎯 CONFIGURANDO WARP TERMINAL AUTOMÁTICAMENTE")
print("=" .. string.rep("=", 45))

-- Función para detectar Warp Terminal
local function detect_warp()
    local term = os.getenv("TERM_PROGRAM")
    local is_warp = term == "WarpTerminal"

    print("\n🔍 Detección de terminal:")
    print("  TERM_PROGRAM:", term or "no detectado")
    print("  Es Warp:", is_warp and "✅" or "❌")

    return is_warp
end

-- Función para verificar si FiraCode Nerd Font está instalada
local function check_nerd_font()
    print("\n📊 Verificando instalación de FiraCode Nerd Font...")

    -- Verificar archivos de fuente en macOS
    local font_paths = {
        os.getenv("HOME") .. "/Library/Fonts/FiraCodeNerdFont-Regular.ttf",
        os.getenv("HOME") .. "/Library/Fonts/FiraCodeNerdFontMono-Regular.ttf",
        "/System/Library/Fonts/Supplemental/FiraCodeNerdFont-Regular.ttf"
    }

    local font_found = false
    for _, path in ipairs(font_paths) do
        local file = io.open(path, "r")
        if file then
            file:close()
            print("  ✅ Encontrada:", path)
            font_found = true
            break
        end
    end

    if not font_found then
        print("  ❌ FiraCode Nerd Font no encontrada en rutas estándar")

        -- Intentar verificar con sistema
        local handle = io.popen("fc-list | grep -i 'firacode.*nerd' | head -1")
        if handle then
            local result = handle:read("*a")
            handle:close()

            if result and result:match("%S") then
                print("  ✅ Detectada por fc-list:", result:gsub("\n", ""))
                font_found = true
            end
        end
    end

    return font_found
end

-- Función para generar configuración de Warp
local function generate_warp_config()
    print("\n⚙️ Generando configuración para Warp...")

    local config_dir = os.getenv("HOME") .. "/.warp"
    local settings_file = config_dir .. "/user_preferences.json"

    -- Crear directorio si no existe
    os.execute("mkdir -p " .. config_dir)

    -- Configuración JSON para Warp
    local warp_config = {
        theme = {
            name = "Default",
        },
        editor = {
            font_family = "FiraCode Nerd Font",
            font_size = 14,
        },
        terminal = {
            font_family = "FiraCode Nerd Font",
            font_size = 14,
        }
    }

    -- Convertir a JSON simple
    local json_config = [=[{
  "theme": {
    "name": "Default"
  },
  "editor": {
    "font_family": "FiraCode Nerd Font",
    "font_size": 14
  },
  "terminal": {
    "font_family": "FiraCode Nerd Font",
    "font_size": 14
  }
}]=]

    -- Escribir configuración
    local file = io.open(settings_file, "w")
    if file then
        file:write(json_config)
        file:close()
        print("  ✅ Configuración guardada en:", settings_file)
        return true
    else
        print("  ❌ No se pudo escribir configuración en:", settings_file)
        return false
    end
end

-- Función para probar iconos Nerd Font
local function test_nerd_font_icons()
    print("\n🧪 PROBANDO ICONOS NERD FONT:")
    print("Si configuraste la fuente correctamente, deberías ver iconos en lugar de símbolos raros:")

    local test_icons = {
        { icon = "", desc = "Carpeta cerrada" },
        { icon = "", desc = "Carpeta abierta" },
        { icon = "", desc = "Archivo genérico" },
        { icon = "󰂺", desc = "README.md" },
        { icon = "󰘦", desc = "YAML" },
        { icon = "󰌠", desc = "Dart" },
        { icon = "󰟆", desc = "Shell script" },
        { icon = "󰈙", desc = "JSON" },
        { icon = "󰌱", desc = "Log file" },
        { icon = "󰙅", desc = "C/C++" },
    }

    for i, item in ipairs(test_icons) do
        print(string.format("  %2d. %s  ← %s", i, item.icon, item.desc))
    end
end

-- Función principal
local function configure_warp_automatically()
    local is_warp = detect_warp()
    local font_installed = check_nerd_font()

    if not font_installed then
        print("\n❌ FiraCode Nerd Font no está instalada.")
        print("📦 Instalándola automáticamente con Homebrew...")

        local install_result = os.execute("brew install --cask font-fira-code-nerd-font 2>/dev/null")
        if install_result == 0 then
            print("✅ FiraCode Nerd Font instalada correctamente")
            font_installed = true
        else
            print("❌ Error instalando la fuente. Instálala manualmente:")
            print("   brew install --cask font-fira-code-nerd-font")
        end
    end

    if is_warp and font_installed then
        print("\n🎯 Configurando Warp automáticamente...")
        local config_success = generate_warp_config()

        if config_success then
            print("\n✅ ¡CONFIGURACIÓN AUTOMÁTICA COMPLETADA!")
            print("\n📋 PASOS FINALES:")
            print("1. Reinicia Warp Terminal COMPLETAMENTE")
            print("2. La fuente ya debería estar configurada automáticamente")
            print("3. Abre nvim y ejecuta <leader>pv")
            print("4. Los iconos deberían aparecer perfectamente")
        end
    elseif is_warp then
        print("\n⚠️  Fuente no disponible. Configuración manual requerida.")
    else
        print("\n💡 INSTRUCCIONES MANUALES:")
        print("Tu terminal no es Warp. Para configurar la fuente:")
        print("1. Abre la configuración de tu terminal")
        print("2. Busca la opción de 'Font' o 'Fuente'")
        print("3. Selecciona 'FiraCode Nerd Font'")
        print("4. Tamaño recomendado: 14pt")
        print("5. Reinicia el terminal")
    end

    test_nerd_font_icons()
end

-- Crear comando permanente
vim.api.nvim_create_user_command("ConfigureWarpFont", function()
    configure_warp_automatically()
end, { desc = "Automatically configure Warp Terminal with Nerd Font" })

-- Ejecutar configuración
configure_warp_automatically()

print("\n💡 Comando creado: :ConfigureWarpFont")