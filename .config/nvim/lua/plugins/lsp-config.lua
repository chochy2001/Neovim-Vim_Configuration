-- Configuración LSP optimizada para tus lenguajes principales
return {
    -- nvim-lspconfig (configuración directa del sistema)
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "hrsh7th/cmp-nvim-lsp" },
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Configuración de LSPs para tus lenguajes principales

            -- 1. Lua LSP (para configuración de Neovim)
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        diagnostics = { globals = { "vim" } },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = { enable = false },
                    },
                },
            })

            -- 2. Dart LSP (configuración robusta con manejo de errores)
            local dart_path = "/Users/jorgesalgadomiranda/development/flutter/bin/dart"
            if vim.fn.executable(dart_path) == 1 then
                lspconfig.dartls.setup({
                    capabilities = capabilities,
                    cmd = { dart_path, "language-server", "--protocol=lsp" },
                    filetypes = { "dart" },
                    root_dir = function(fname)
                        return lspconfig.util.root_pattern("pubspec.yaml")(fname) or
                               lspconfig.util.root_pattern(".git")(fname) or
                               vim.fn.getcwd()
                    end,
                    single_file_support = true,
                    init_options = {
                        onlyAnalyzeProjectsWithOpenFiles = true, -- Más conservador
                        suggestFromUnimportedLibraries = true,
                        closingLabels = true,
                        outline = true,
                        flutterOutline = false,
                    },
                    settings = {
                        dart = {
                            completeFunctionCalls = true,
                            showTodos = false, -- Deshabilitar para reducir carga
                            enableSnippets = true,
                            updateImportsOnRename = true,
                            lineLength = 80,
                        }
                    },
                    on_attach = function(client, bufnr)
                        -- Configuración específica para dart
                        if client.server_capabilities.documentFormattingProvider then
                            vim.api.nvim_create_autocmd("BufWritePre", {
                                buffer = bufnr,
                                callback = function()
                                    vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 2000 })
                                end,
                            })
                        end
                    end,
                })
            else
                vim.notify("Dart executable not found at: " .. dart_path, vim.log.levels.WARN)
            end

            -- 3. C/C++ LSP (lenguaje principal)
            if vim.fn.executable("clangd") == 1 then
                lspconfig.clangd.setup({
                    capabilities = capabilities,
                    cmd = {
                        "clangd",
                        "--background-index",
                        "--suggest-missing-includes",
                        "--clang-tidy",
                        "--header-insertion=iwyu",
                        "--completion-style=detailed",
                        "--function-arg-placeholders",
                    },
                    filetypes = { "c", "cpp", "objc", "objcpp" },
                })
            end

            -- 4. Swift LSP (lenguaje principal)
            if vim.fn.executable("sourcekit-lsp") == 1 then
                lspconfig.sourcekit.setup({
                    capabilities = capabilities,
                    cmd = { "sourcekit-lsp" },
                    filetypes = { "swift" },
                })
            end

            -- 5. Kotlin LSP (lenguaje principal)
            if vim.fn.executable("kotlin-language-server") == 1 then
                lspconfig.kotlin_language_server.setup({
                    capabilities = capabilities,
                    cmd = { "kotlin-language-server" },
                    filetypes = { "kotlin" },
                    root_dir = lspconfig.util.root_pattern("settings.gradle.kts", "settings.gradle", "build.gradle.kts", "build.gradle"),
                })
            end

            -- 6. JSON LSP (configuraciones)
            if vim.fn.executable("vscode-json-language-server") == 1 then
                lspconfig.jsonls.setup({
                    capabilities = capabilities,
                    cmd = { "vscode-json-language-server", "--stdio" },
                    settings = {
                        json = {
                            schemas = (function()
                                local ok, schemastore = pcall(require, 'schemastore')
                                if ok and schemastore and schemastore.json and schemastore.json.schemas then
                                    return schemastore.json.schemas()
                                else
                                    return {}
                                end
                            end)(),
                            validate = { enable = true },
                        },
                    },
                })
            end

            -- 7. YAML LSP (configuraciones Flutter/Android)
            if vim.fn.executable("yaml-language-server") == 1 then
                lspconfig.yamlls.setup({
                    capabilities = capabilities,
                    settings = {
                        yaml = {
                            keyOrdering = false,
                            format = {
                                enable = true,
                            },
                            hover = true,
                            completion = true,
                            validate = true,
                            schemas = {
                                ["https://json.schemastore.org/pubspec.json"] = "pubspec.yaml",
                                ["https://json.schemastore.org/chart.json"] = "Chart.yaml",
                            },
                        },
                    },
                })
            end

            -- Keymaps optimizados para LSP
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    local opts = { buffer = ev.buf, silent = true }

                    -- Navegación LSP con leader
                    vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to Declaration" }))
                    vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to Definition" }))
                    vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to Implementation" }))
                    vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "References" }))
                    vim.keymap.set("n", "<leader>gT", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Type Definition" }))

                    -- Información LSP con leader
                    vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "LSP: Hover Documentation" }))
                    vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "LSP: Signature Help" }))

                    -- Acciones
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename Symbol" }))
                    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code Action" }))
                    vim.keymap.set("n", "<leader>lf", function()
                        vim.lsp.buf.format { async = true }
                    end, vim.tbl_extend("force", opts, { desc = "LSP: Format Document" }))

                    -- Workspace (comandos simplificados para uso ocasional)
                    vim.keymap.set("n", "<leader>lw", function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, vim.tbl_extend("force", opts, { desc = "LSP: List Workspace Folders" }))

                    -- AGREGADOS: comandos LSP faltantes para sincronización completa
                    vim.keymap.set("i", "<C-space>", "<C-x><C-o>", vim.tbl_extend("force", opts, { desc = "Force LSP Completion" }))
                    vim.keymap.set("n", "<leader>I", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Quick Implementations" }))
                end,
            })

            -- Configurar diagnósticos
            vim.diagnostic.config({
                virtual_text = {
                    prefix = "●",
                    source = "if_many",
                },
                float = {
                    source = "always",
                    border = "rounded",
                },
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
            })

            -- Signos de diagnósticos
            local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end
        end,
    },

    -- SchemaStore para mejor soporte JSON
    {
        "b0o/schemastore.nvim",
        lazy = true,
    },
}