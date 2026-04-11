-- LSP configuration using Neovim 0.12 native API (vim.lsp.config / vim.lsp.enable)
return {
    -- nvim-lspconfig provides server definitions in lsp/ directory
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "hrsh7th/cmp-nvim-lsp" },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Platform detection
            local is_win = vim.fn.has("win32") == 1
            local is_mac = vim.fn.has("mac") == 1
            local sep = is_win and "\\" or "/"

            -- 1. Lua LSP (for Neovim configuration)
            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        diagnostics = { globals = { "vim" } },
                        workspace = {
                            library = { vim.env.VIMRUNTIME },
                            checkThirdParty = false,
                        },
                        telemetry = { enable = false },
                    },
                },
            })

            -- 2. Dart LSP
            local flutter_home = os.getenv("FLUTTER_HOME")
                or (vim.fn.expand("$HOME") .. sep .. "development" .. sep .. "flutter")
            local dart_path = vim.fn.exepath("dart")
            if dart_path == "" then
                dart_path = flutter_home .. sep .. "bin" .. sep .. (is_win and "dart.bat" or "dart")
            end
            if vim.fn.executable(dart_path) == 1 then
                vim.lsp.config("dartls", {
                    capabilities = capabilities,
                    cmd = { dart_path, "language-server", "--protocol=lsp" },
                    filetypes = { "dart" },
                    root_markers = { "pubspec.yaml", ".git" },
                    single_file_support = true,
                    init_options = {
                        onlyAnalyzeProjectsWithOpenFiles = true,
                        suggestFromUnimportedLibraries = true,
                        closingLabels = true,
                        outline = true,
                        flutterOutline = false,
                    },
                    settings = {
                        dart = {
                            completeFunctionCalls = true,
                            showTodos = false,
                            enableSnippets = true,
                            updateImportsOnRename = true,
                            lineLength = 80,
                        },
                    },
                    on_attach = function(client, bufnr)
                        if client:supports_method("textDocument/formatting") then
                            vim.api.nvim_create_autocmd("BufWritePre", {
                                buffer = bufnr,
                                callback = function()
                                    vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 2000 })
                                end,
                            })
                        end
                    end,
                })
            end

            -- 3. C/C++ LSP
            if vim.fn.executable("clangd") == 1 then
                vim.lsp.config("clangd", {
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

            -- 4. Swift LSP (macOS only)
            if is_mac and vim.fn.executable("sourcekit-lsp") == 1 then
                vim.lsp.config("sourcekit", {
                    capabilities = capabilities,
                    cmd = { "sourcekit-lsp" },
                    filetypes = { "swift" },
                })
            end

            -- 5. Kotlin LSP
            if vim.fn.executable("kotlin-language-server") == 1 then
                vim.lsp.config("kotlin_language_server", {
                    capabilities = capabilities,
                    cmd = { "kotlin-language-server" },
                    filetypes = { "kotlin" },
                    root_markers = { "settings.gradle.kts", "settings.gradle", "build.gradle.kts", "build.gradle" },
                })
            end

            -- 6. JSON LSP
            if vim.fn.executable("vscode-json-language-server") == 1 then
                vim.lsp.config("jsonls", {
                    capabilities = capabilities,
                    cmd = { "vscode-json-language-server", "--stdio" },
                    settings = {
                        json = {
                            schemas = (function()
                                local ok, schemastore = pcall(require, "schemastore")
                                if ok then return schemastore.json.schemas() end
                                return {}
                            end)(),
                            validate = { enable = true },
                        },
                    },
                })
            end

            -- 7. YAML LSP
            if vim.fn.executable("yaml-language-server") == 1 then
                vim.lsp.config("yamlls", {
                    capabilities = capabilities,
                    settings = {
                        yaml = {
                            keyOrdering = false,
                            format = { enable = true },
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

            -- Enable all configured servers
            vim.lsp.enable({
                "lua_ls", "clangd", "jsonls", "yamlls",
                "kotlin_language_server", "sourcekit", "dartls",
            })

            -- LSP keymaps on attach
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    local opts = { buffer = ev.buf, silent = true }

                    -- Code Actions & Refactoring
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename Symbol" }))
                    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code Action" }))

                    -- Navigation
                    vim.keymap.set("n", "go", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Go to Type Definition" }))
                    vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature Help" }))

                    -- Format
                    vim.keymap.set("n", "<leader>fm", function()
                        vim.lsp.buf.format({ bufnr = ev.buf, async = true })
                    end, vim.tbl_extend("force", opts, { desc = "Format document" }))

                    -- Completion (insert mode)
                    vim.keymap.set("i", "<C-space>", "<C-x><C-o>", vim.tbl_extend("force", opts, { desc = "LSP Completion" }))
                end,
            })

            -- Configure diagnostics
            vim.diagnostic.config({
                virtual_text = {
                    prefix = "●",
                    source = "if_many",
                },
                float = {
                    source = true,
                    border = "rounded",
                },
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = " ",
                        [vim.diagnostic.severity.WARN] = " ",
                        [vim.diagnostic.severity.HINT] = " ",
                        [vim.diagnostic.severity.INFO] = " ",
                    },
                },
                underline = true,
                update_in_insert = false,
                severity_sort = true,
            })
        end,
    },

    -- SchemaStore for better JSON support
    {
        "b0o/schemastore.nvim",
        lazy = true,
    },

    -- Mason: auto-install LSP servers, formatters, and debuggers
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
        opts = {
            ui = { border = "rounded" },
        },
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        opts = {
            ensure_installed = {
                "lua_ls",
                "clangd",
                "jsonls",
                "yamlls",
            },
            automatic_enable = true,
        },
    },

    -- LSP progress indicator
    {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        opts = {
            notification = {
                window = { winblend = 0 },
            },
        },
    },
}
