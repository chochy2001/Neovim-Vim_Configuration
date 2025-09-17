-- Test script para verificar la configuración de Flutter

local function test_flutter_setup()
    print("🧪 PROBANDO CONFIGURACIÓN FLUTTER")
    print("=" .. string.rep("=", 35))

    -- Test 1: Verificar Flutter
    local flutter_cmd = "/Users/jorgesalgadomiranda/development/flutter/bin/flutter"
    if vim.fn.executable(flutter_cmd) == 1 then
        print("✅ Flutter encontrado: " .. flutter_cmd)
    else
        print("❌ Flutter NO encontrado")
    end

    -- Test 2: Verificar Dart
    local dart_cmd = "/Users/jorgesalgadomiranda/development/flutter/bin/dart"
    if vim.fn.executable(dart_cmd) == 1 then
        print("✅ Dart encontrado: " .. dart_cmd)
    else
        print("❌ Dart NO encontrado")
    end

    -- Test 3: Verificar LSP clients
    local clients = vim.lsp.get_active_clients()
    print("\n📋 Clientes LSP activos:")
    if #clients == 0 then
        print("  - Ninguno (normal si no hay archivos .dart abiertos)")
    else
        for _, client in ipairs(clients) do
            print("  - " .. client.name .. " (id: " .. client.id .. ")")
        end
    end

    -- Test 4: Verificar plugins Flutter
    local flutter_tools_loaded = pcall(require, "flutter-tools")
    print("\n🔌 Estado de plugins:")
    print("  - flutter-tools.nvim: " .. (flutter_tools_loaded and "✅ Cargado" or "❌ Error"))

    -- Test 5: Mostrar keymaps disponibles
    print("\n⌨️  Keymaps Flutter disponibles:")
    print("  - <leader>Fs: Flutter run")
    print("  - <leader>Fr: Hot reload")
    print("  - <leader>FR: Hot restart")
    print("  - <leader>Fd: DevTools")
    print("  - <leader>Fe: Start emulator")
    print("  - <leader>FD: Select device")

    print("\n💡 Para probar:")
    print("  1. Abre un archivo .dart")
    print("  2. Ejecuta :LspInfo para ver el estado del LSP")
    print("  3. Usa <leader>Fs para ejecutar Flutter")
    print("\n🎉 Test completado!")
end

-- Crear comando
vim.api.nvim_create_user_command("TestFlutter", test_flutter_setup, { desc = "Test Flutter configuration" })

-- Ejecutar automáticamente
test_flutter_setup()

return { test = test_flutter_setup }