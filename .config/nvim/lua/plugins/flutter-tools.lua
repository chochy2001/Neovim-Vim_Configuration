-- Herramientas específicas para desarrollo Flutter
return {
    -- Plugin principal para Flutter
    {
        "akinsho/flutter-tools.nvim",
        ft = "dart",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "stevearc/dressing.nvim", -- UI opcional mejorada
            "mfussenegger/nvim-dap", -- Requerido para debugging
        },
        config = function()
            -- Configuración segura de flutter-tools con manejo de errores
            local ok, flutter_tools = pcall(require, "flutter-tools")
            if not ok then
                vim.notify("flutter-tools.nvim no se pudo cargar", vim.log.levels.WARN)
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
                    }
                },
                debugger = {
                    enabled = true,
                    run_via_dap = true, -- usar nvim-dap
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
                            }
                        }
                    end,
                },
                flutter_path = "/Users/jorgesalgadomiranda/development/flutter/bin/flutter", -- Ruta específica
                flutter_lookup_cmd = nil, -- Usar ruta específica en lugar de which
                root_patterns = { ".git", "pubspec.yaml" },
                fvm = false, -- true si usas Flutter Version Management
                widget_guides = {
                    enabled = true,
                },
                closing_tags = {
                    highlight = "Comment",
                    prefix = "// ",
                    enabled = true
                },
                dev_log = {
                    enabled = true,
                    notify_errors = false, -- evita spam de notificaciones
                    open_cmd = "15split", -- comando para abrir log
                },
                dev_tools = {
                    autostart = false, -- true para auto-abrir devtools
                    auto_open_browser = false,
                },
                outline = {
                    open_cmd = "30vnew", -- comando para abrir outline
                    auto_open = false,
                },
                lsp = {
                    -- COMPLETAMENTE DESHABILITADO - usamos configuración manual en lsp-config.lua
                    -- Esto evita conflictos de transport y múltiples clientes LSP
                    enable = false,
                    auto_start = false,
                    color = {
                        enabled = false,
                    },
                    -- Sin configuración on_attach ya que LSP está deshabilitado
                }
            })

            -- Keymaps globales para Flutter - sincronizado con .ideavimrc
            -- Hot Reload y Restart principales (coinciden con Android Studio)
            vim.keymap.set("n", "<leader>Fr", "<cmd>FlutterReload<cr>", { desc = "Flutter: Hot Reload" })
            vim.keymap.set("n", "<leader>FR", "<cmd>FlutterRestart<cr>", { desc = "Flutter: Hot Restart" })
            vim.keymap.set("n", "<leader>Fd", "<cmd>FlutterDevTools<cr>", { desc = "Flutter: DevTools" })

            -- Comandos adicionales útiles (no conflictan con .ideavimrc)
            vim.keymap.set("n", "<leader>Fs", "<cmd>FlutterRun<cr>", { desc = "Flutter: Start App" })
            vim.keymap.set("n", "<leader>FD", "<cmd>FlutterDevices<cr>", { desc = "Flutter: Select Device" })
            vim.keymap.set("n", "<leader>Fe", "<cmd>FlutterEmulators<cr>", { desc = "Flutter: Start Emulator" })

            -- AGREGADOS: comandos Flutter faltantes para sincronización completa
            vim.keymap.set("n", "<leader>Fq", "<cmd>FlutterQuit<cr>", { desc = "Flutter: Quit/Stop" })
            vim.keymap.set("n", "<leader>Fo", "<cmd>FlutterOutlineToggle<cr>", { desc = "Flutter: Toggle Outline" })
            vim.keymap.set("n", "<leader>Fc", "<cmd>FlutterLogClear<cr>", { desc = "Flutter: Clear Log" })
            vim.keymap.set("n", "<leader>Ft", "<cmd>FlutterCopyProfilerUrl<cr>", { desc = "Flutter: Copy Profiler URL" })
            vim.keymap.set("n", "<leader>Fl", "<cmd>FlutterLspRestart<cr>", { desc = "Flutter: Restart LSP" })
        end,
    },

    -- Snippets específicos para Dart/Flutter
    {
        "Neevash/awesome-flutter-snippets",
        ft = "dart",
        dependencies = { "L3MON4D3/LuaSnip" },
    },

    -- Mejor syntax highlighting para Dart
    {
        "dart-lang/dart-vim-plugin",
        ft = "dart",
        config = function()
            vim.g.dart_style_guide = 2 -- usar el style guide oficial
            vim.g.dart_format_on_save = 1 -- formatear al guardar
        end
    },
}