-- Script para configurar terminal del sistema con Nerd Font
-- Ejecutar con: :luafile ~/.config/nvim/lua/configure-system-terminal.lua

print("🖥️  CONFIGURANDO TERMINAL DEL SISTEMA")
print("=" .. string.rep("=", 40))

-- Función para detectar qué terminal se está usando
local function detect_terminal_type()
    local term_program = os.getenv("TERM_PROGRAM")
    local term = os.getenv("TERM")
    local iterm_session = os.getenv("ITERM_SESSION_ID")

    print("\n🔍 Detección de terminal:")
    print("  TERM_PROGRAM:", term_program or "no detectado")
    print("  TERM:", term or "no detectado")
    print("  ITERM_SESSION_ID:", iterm_session and "presente" or "no detectado")

    if term_program == "Apple_Terminal" then
        return "apple_terminal"
    elseif term_program == "iTerm.app" or iterm_session then
        return "iterm2"
    elseif term_program == "WarpTerminal" then
        return "warp"
    elseif term_program == "vscode" then
        return "vscode"
    else
        return "unknown"
    end
end

-- Función para configurar Apple Terminal
local function configure_apple_terminal()
    print("\n🍎 Configurando Apple Terminal...")

    -- Crear script AppleScript para configurar la fuente
    local applescript = [[
tell application "Terminal"
    set currentSettings to default settings
    set font name of currentSettings to "FiraCodeNerdFontMono-Regular"
    set font size of currentSettings to 14
end tell
]]

    -- Escribir script temporal
    local script_path = "/tmp/configure_terminal.scpt"
    local file = io.open(script_path, "w")
    if file then
        file:write(applescript)
        file:close()

        -- Ejecutar script
        local result = os.execute("osascript " .. script_path .. " 2>/dev/null")
        os.execute("rm " .. script_path)

        if result == 0 then
            print("✅ Apple Terminal configurado con FiraCode Nerd Font")
            return true
        else
            print("❌ Error configurando Apple Terminal automáticamente")
        end
    end

    print("📋 CONFIGURACIÓN MANUAL para Apple Terminal:")
    print("1. Abre Terminal.app")
    print("2. Ve a Terminal → Preferences (Cmd + ,)")
    print("3. En la pestaña 'Profiles', selecciona tu perfil")
    print("4. Pestaña 'Text' → cambia Font a 'FiraCode Nerd Font Mono'")
    print("5. Tamaño: 14pt")
    print("6. Cierra y reabre Terminal")

    return false
end

-- Función para configurar iTerm2
local function configure_iterm2()
    print("\n🟦 Configurando iTerm2...")

    -- Crear configuración para iTerm2 usando defaults
    local commands = {
        'defaults write com.googlecode.iterm2 "Normal Font" "FiraCodeNerdFontMono-Regular 14"',
        'defaults write com.googlecode.iterm2 "Terminal Type" "xterm-256color"'
    }

    local success = true
    for _, cmd in ipairs(commands) do
        local result = os.execute(cmd .. " 2>/dev/null")
        if result ~= 0 then
            success = false
        end
    end

    if success then
        print("✅ iTerm2 configurado con FiraCode Nerd Font")
        print("⚠️  Reinicia iTerm2 para que los cambios tengan efecto")
        return true
    else
        print("❌ Error configurando iTerm2 automáticamente")
    end

    print("📋 CONFIGURACIÓN MANUAL para iTerm2:")
    print("1. Abre iTerm2")
    print("2. Ve a iTerm2 → Preferences (Cmd + ,)")
    print("3. Profiles → Text")
    print("4. Cambia Font a 'FiraCode Nerd Font Mono'")
    print("5. Tamaño: 14")
    print("6. Reinicia iTerm2")

    return false
end

-- Función para configurar VS Code terminal
local function configure_vscode()
    print("\n📝 Configurando VS Code Terminal...")

    local vscode_settings = os.getenv("HOME") .. "/Library/Application Support/Code/User/settings.json"

    print("📋 CONFIGURACIÓN MANUAL para VS Code:")
    print("1. Abre VS Code")
    print("2. Cmd + , para abrir Settings")
    print("3. Busca 'terminal.integrated.fontFamily'")
    print("4. Cambia a: 'FiraCode Nerd Font Mono'")
    print("5. Busca 'terminal.integrated.fontSize'")
    print("6. Cambia a: 14")
    print("7. Reinicia VS Code")

    -- También agregar a settings.json si es posible
    print("\n💡 O agrega esto a tu settings.json:")
    print('  "terminal.integrated.fontFamily": "FiraCode Nerd Font Mono",')
    print('  "terminal.integrated.fontSize": 14')

    return false
end

-- Función para probar iconos en terminal actual
local function test_terminal_icons()
    print("\n🧪 PROBANDO ICONOS EN TERMINAL ACTUAL:")
    print("Si la fuente está configurada correctamente, deberías ver iconos:")

    local test_chars = {
        { char = "", name = "nf-fa-folder (carpeta)" },
        { char = "", name = "nf-fa-file_o (archivo)" },
        { char = "", name = "nf-dev-git (git)" },
        { char = "", name = "nf-mdi-language_markdown (markdown)" },
        { char = "", name = "nf-seti-yaml (yaml)" },
        { char = "", name = "nf-seti-dart (dart)" },
    }

    for i, item in ipairs(test_chars) do
        print(string.format("  %d. %s ← %s", i, item.char, item.name))
    end

    print("\n❓ Si ves símbolos raros arriba:")
    print("  → La fuente no está configurada correctamente en tu terminal")
    print("  → Sigue las instrucciones específicas para tu terminal")
end

-- Función para crear configuración de fallback
local function create_fallback_config()
    print("\n🔄 Creando configuración de fallback para iconos...")

    -- Crear configuración simple sin Nerd Font
    local fallback_config = [[
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
]]

    local fallback_file = vim.fn.stdpath("config") .. "/lua/icons-fallback.lua"
    local file = io.open(fallback_file, "w")
    if file then
        file:write(fallback_config)
        file:close()
        print("✅ Configuración fallback creada:", fallback_file)

        -- Crear comando para activar fallback
        vim.api.nvim_create_user_command("UseFallbackIcons", function()
            require("icons-fallback").setup_fallback_icons()
            print("🔄 Iconos fallback activados (letras simples)")
        end, { desc = "Use simple ASCII icons instead of Nerd Font" })
    end
end

-- Función principal
local function configure_system_terminal()
    local terminal_type = detect_terminal_type()

    print("\n🎯 Terminal detectado:", terminal_type)

    local configured = false

    if terminal_type == "apple_terminal" then
        configured = configure_apple_terminal()
    elseif terminal_type == "iterm2" then
        configured = configure_iterm2()
    elseif terminal_type == "warp" then
        print("\n✅ Warp ya fue configurado anteriormente")
        configured = true
    elseif terminal_type == "vscode" then
        configured = configure_vscode()
    else
        print("\n❓ Terminal no reconocido o genérico")
    end

    test_terminal_icons()
    create_fallback_config()

    print("\n🎯 PRÓXIMOS PASOS:")
    if configured then
        print("1. Reinicia tu terminal/aplicación")
        print("2. Abre nvim")
        print("3. Ejecuta <leader>pv")
        print("4. Los iconos deberían verse correctamente")
    else
        print("1. Sigue las instrucciones manuales arriba")
        print("2. Reinicia tu terminal")
        print("3. Si siguen sin funcionar, usa: :UseFallbackIcons")
    end

    print("\n💡 COMANDOS DISPONIBLES:")
    print("• :ConfigureSystemTerminal - Ejecutar esta configuración")
    print("• :UseFallbackIcons - Usar iconos ASCII simples")
end

-- Crear comando
vim.api.nvim_create_user_command("ConfigureSystemTerminal", function()
    configure_system_terminal()
end, { desc = "Configure system terminal for Nerd Font icons" })

-- Ejecutar configuración
configure_system_terminal()

print("\n💡 Comando creado: :ConfigureSystemTerminal")