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
            require("flutter-tools").setup({
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
                flutter_path = nil, -- Detecta automáticamente
                flutter_lookup_cmd = "which flutter", -- comando para encontrar flutter
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
                    color = { -- color de widgets Flutter
                        enabled = true,
                        background = false,
                        background_color = nil,
                        foreground = false,
                        virtual_text = true,
                        virtual_text_str = "■",
                    },
                    on_attach = function(_, bufnr)
                        -- Keymaps específicos para Flutter cuando LSP se adjunta
                        local opts = { buffer = bufnr, silent = true }
                        vim.keymap.set("n", "<leader>Fo", "<cmd>FlutterOutlineToggle<cr>",
                            vim.tbl_extend("force", opts, { desc = "Flutter: Toggle Outline" }))
                        vim.keymap.set("n", "<leader>Fr", "<cmd>FlutterReload<cr>",
                            vim.tbl_extend("force", opts, { desc = "Flutter: Hot Reload" }))
                        vim.keymap.set("n", "<leader>FR", "<cmd>FlutterRestart<cr>",
                            vim.tbl_extend("force", opts, { desc = "Flutter: Hot Restart" }))
                        vim.keymap.set("n", "<leader>Fd", "<cmd>FlutterDevTools<cr>",
                            vim.tbl_extend("force", opts, { desc = "Flutter: Open DevTools" }))
                        vim.keymap.set("n", "<leader>Fc", "<cmd>FlutterLogClear<cr>",
                            vim.tbl_extend("force", opts, { desc = "Flutter: Clear Log" }))
                        vim.keymap.set("n", "<leader>Fq", "<cmd>FlutterQuit<cr>",
                            vim.tbl_extend("force", opts, { desc = "Flutter: Quit" }))
                    end,
                    capabilities = require("cmp_nvim_lsp").default_capabilities(),
                    -- settings para el LSP de Dart
                    settings = {
                        showTodos = true,
                        completeFunctionCalls = true,
                        analysisExcludedFolders = {
                            vim.fn.expand("$HOME/AppData/Local/Pub/Cache"),
                            vim.fn.expand("$HOME/.pub-cache"),
                            vim.fn.expand("/opt/homebrew"),
                            vim.fn.expand("$HOME/tools/flutter"),
                        },
                        renameFilesWithClasses = "prompt",
                        enableSnippets = true,
                        updateImportsOnRename = true,
                    }
                }
            })

            -- Keymaps globales para Flutter
            vim.keymap.set("n", "<leader>Fs", "<cmd>FlutterRun<cr>", { desc = "Flutter: Start App" })
            vim.keymap.set("n", "<leader>FD", "<cmd>FlutterDevices<cr>", { desc = "Flutter: Select Device" })
            vim.keymap.set("n", "<leader>Fe", "<cmd>FlutterEmulators<cr>", { desc = "Flutter: Start Emulator" })
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