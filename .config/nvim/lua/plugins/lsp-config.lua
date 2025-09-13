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

            -- 2. Dart LSP (Flutter/Dart - lenguaje principal)
            if vim.fn.executable("dart") == 1 then
                lspconfig.dartls.setup({
                    capabilities = capabilities,
                    cmd = { "dart", "language-server", "--protocol=lsp" },
                    filetypes = { "dart" },
                    init_options = {
                        onlyAnalyzeProjectsWithOpenFiles = false,
                        suggestFromUnimportedLibraries = true,
                        closingLabels = true,
                        outline = true,
                        flutterOutline = true,
                    },
                    settings = {
                        dart = {
                            completeFunctionCalls = true,
                            showTodos = true,
                        }
                    }
                })
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
            lspconfig.jsonls.setup({
                capabilities = capabilities,
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

                    -- Navegación
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to Declaration" }))
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to Definition" }))
                    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to Implementation" }))
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "References" }))
                    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Type Definition" }))

                    -- Información
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover Documentation" }))
                    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature Help" }))

                    -- Acciones
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename Symbol" }))
                    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code Action" }))
                    vim.keymap.set("n", "<leader>f", function()
                        vim.lsp.buf.format { async = true }
                    end, vim.tbl_extend("force", opts, { desc = "Format Document" }))

                    -- Workspace
                    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, vim.tbl_extend("force", opts, { desc = "Add Workspace Folder" }))
                    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, vim.tbl_extend("force", opts, { desc = "Remove Workspace Folder" }))
                    vim.keymap.set("n", "<leader>wl", function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, vim.tbl_extend("force", opts, { desc = "List Workspace Folders" }))
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