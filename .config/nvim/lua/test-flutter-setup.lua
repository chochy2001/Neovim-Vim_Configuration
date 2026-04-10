-- Test script to verify the Flutter configuration

local function test_flutter_setup()
    print("TESTING FLUTTER CONFIGURATION")
    print("=" .. string.rep("=", 35))

    -- Test 1: Check Flutter
    local flutter_home = os.getenv("FLUTTER_HOME")
        or (vim.fn.expand("$HOME") .. "/development/flutter")
    local flutter_cmd = vim.fn.executable("flutter") == 1
        and vim.fn.exepath("flutter")
        or (flutter_home .. "/bin/flutter")
    if vim.fn.executable(flutter_cmd) == 1 then
        print("Flutter found: " .. flutter_cmd)
    else
        print("Flutter NOT found")
    end

    -- Test 2: Check Dart
    local dart_cmd = vim.fn.executable("dart") == 1
        and vim.fn.exepath("dart")
        or (flutter_home .. "/bin/dart")
    if vim.fn.executable(dart_cmd) == 1 then
        print("Dart found: " .. dart_cmd)
    else
        print("Dart NOT found")
    end

    -- Test 3: Check LSP clients
    local clients = vim.lsp.get_clients()
    print("\nActive LSP clients:")
    if #clients == 0 then
        print("  - None (normal if no .dart files are open)")
    else
        for _, client in ipairs(clients) do
            print("  - " .. client.name .. " (id: " .. client.id .. ")")
        end
    end

    -- Test 4: Check Flutter plugins
    local flutter_tools_loaded = pcall(require, "flutter-tools")
    print("\nPlugin status:")
    print("  - flutter-tools.nvim: " .. (flutter_tools_loaded and "Loaded" or "Error"))

    -- Test 5: Show available keymaps
    print("\nAvailable Flutter keymaps:")
    print("  - <leader>Fs: Flutter run")
    print("  - <leader>Fr: Hot reload")
    print("  - <leader>FR: Hot restart")
    print("  - <leader>Fd: DevTools")
    print("  - <leader>Fe: Start emulator")
    print("  - <leader>FD: Select device")

    print("\nTo test:")
    print("  1. Open a .dart file")
    print("  2. Run :LspInfo to see LSP status")
    print("  3. Use <leader>Fs to run Flutter")
    print("\nTest completed!")
end

-- Create command
vim.api.nvim_create_user_command("TestFlutter", test_flutter_setup, { desc = "Test Flutter configuration" })

-- Only run on demand with :TestFlutter (not at startup)
return { test = test_flutter_setup }