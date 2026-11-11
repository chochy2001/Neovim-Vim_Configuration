-- Flutter-specific development tools
-- flutter-tools creates its :Flutter* commands when the first Dart buffer
-- opens. Before that, say what to do instead of failing with E492.
local function flutter(command)
    return function()
        if vim.fn.exists(":" .. command) == 2 then
            vim.cmd(command)
        else
            vim.notify(
                "Flutter: open a .dart file of a Flutter project first ("
                    .. command
                    .. " is not available yet).",
                vim.log.levels.WARN
            )
        end
    end
end

return {
    -- Main Flutter plugin
    {
        "nvim-flutter/flutter-tools.nvim",
        ft = "dart",
        keys = {
            { "<leader>flr", flutter("FlutterReload"), desc = "Flutter: Hot Reload" },
            { "<leader>fls", flutter("FlutterRestart"), desc = "Flutter: Hot Restart" },
            { "<leader>fld", flutter("FlutterDevTools"), desc = "Flutter: DevTools" },
            { "<leader>fla", flutter("FlutterRun"), desc = "Flutter: Start App" },
            { "<leader>flsd", flutter("FlutterDevices"), desc = "Flutter: Select Device" },
            { "<leader>fle", flutter("FlutterEmulators"), desc = "Flutter: Start Emulator" },
            { "<leader>flq", flutter("FlutterQuit"), desc = "Flutter: Quit/Stop" },
            { "<leader>flo", flutter("FlutterOutlineToggle"), desc = "Flutter: Toggle Outline" },
            { "<leader>flc", flutter("FlutterLogClear"), desc = "Flutter: Clear Log" },
            { "<leader>flp", flutter("FlutterCopyProfilerUrl"), desc = "Flutter: Copy Profiler URL" },
            { "<leader>fll", flutter("FlutterLspRestart"), desc = "Flutter: Restart LSP" },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "mfussenegger/nvim-dap", -- Required for debugging
        },
        config = function()
            -- Safe flutter-tools configuration with error handling
            local ok, flutter_tools = pcall(require, "flutter-tools")
            if not ok then
                vim.notify("flutter-tools.nvim failed to load", vim.log.levels.WARN)
                return
            end

            flutter_tools.setup({
                ui = {
                    border = "rounded",
                    notification_style = "nvim-notify",
                },
                decorations = {
                    statusline = {
                        app_version = false,
                        device = true,
                        project_config = false,
                    },
                },
                debugger = {
                    enabled = true,
                    run_via_dap = true, -- use nvim-dap
                    exception_breakpoints = {},
                    register_configurations = function(paths)
                        local dap_ok, dap = pcall(require, "dap")
                        if not dap_ok then
                            vim.notify("nvim-dap not available for Flutter debugging", vim.log.levels.WARN)
                            return
                        end
                        dap.configurations.dart = {
                            {
                                type = "dart",
                                request = "launch",
                                name = "Launch Flutter",
                                dartSdkPath = paths.dart_sdk,
                                flutterSdkPath = paths.flutter_sdk,
                                program = "${workspaceFolder}/lib/main.dart",
                                cwd = "${workspaceFolder}",
                            },
                            {
                                type = "dart",
                                request = "attach",
                                name = "Connect Flutter",
                                dartSdkPath = paths.dart_sdk,
                                flutterSdkPath = paths.flutter_sdk,
                                cwd = "${workspaceFolder}",
                            },
                        }
                    end,
                },
                flutter_path = (function()
                    local is_win = vim.fn.has("win32") == 1
                    local sep = is_win and "\\" or "/"
                    local flutter_exe = is_win and "flutter.bat" or "flutter"
                    -- Try to find in PATH
                    if vim.fn.executable(flutter_exe) == 1 then
                        return vim.fn.exepath(flutter_exe)
                    end
                    if vim.fn.executable("flutter") == 1 then
                        return vim.fn.exepath("flutter")
                    end
                    -- Fallback to conventional directory
                    local home = vim.uv.os_homedir() or vim.fn.expand("$HOME")
                    local fhome = os.getenv("FLUTTER_HOME")
                        or (home .. sep .. "development" .. sep .. "flutter")
                    return fhome .. sep .. "bin" .. sep .. flutter_exe
                end)(),
                flutter_lookup_cmd = nil,
                root_patterns = { ".git", "pubspec.yaml" },
                fvm = false, -- true if you use Flutter Version Management
                widget_guides = {
                    enabled = true,
                },
                closing_tags = {
                    highlight = "Comment",
                    prefix = "// ",
                    enabled = true,
                },
                dev_log = {
                    enabled = true,
                    notify_errors = false, -- avoid notification spam
                    open_cmd = "15split", -- command to open log
                },
                dev_tools = {
                    autostart = false, -- true to auto-open devtools
                    auto_open_browser = false,
                },
                outline = {
                    open_cmd = "30vnew", -- command to open outline
                    auto_open = false,
                },
                -- dartls is started here (flutter-tools always attaches).
                -- Do not also enable dartls in lsp-config.lua.
                lsp = {
                    capabilities = require("cmp_nvim_lsp").default_capabilities(),
                    -- NOTE: no `color` table: plugin-managed colors are
                    -- deprecated on Neovim 0.12+
                },
            })
        end,
    },

    -- Dart/Flutter-specific snippets
    {
        "Neevash/awesome-flutter-snippets",
        ft = "dart",
        dependencies = { "L3MON4D3/LuaSnip" },
    },

    -- Better syntax highlighting for Dart
    {
        "dart-lang/dart-vim-plugin",
        ft = "dart",
        config = function()
            vim.g.dart_style_guide = 2 -- use the official style guide
            -- Format-on-save is none-ls / <leader>fm only (this flag would
            -- stack a third dart format on top of dartls + none-ls)
            vim.g.dart_format_on_save = 0
        end,
    },
}
