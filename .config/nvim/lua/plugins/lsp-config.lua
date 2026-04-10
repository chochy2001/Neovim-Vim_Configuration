-- Optimized LSP configuration for your main languages
return {
    -- nvim-lspconfig (direct system configuration)
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "hrsh7th/cmp-nvim-lsp" },
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Platform detection
            local is_win = vim.fn.has("win32") == 1
            local is_mac = vim.fn.has("mac") == 1
            local sep = is_win and "\\" or "/"

            -- Helper: find executable with .bat/.exe variant on Windows
            local function find_exe(cmd)
                if vim.fn.executable(cmd) == 1 then return vim.fn.exepath(cmd) end
                if is_win then
                    for _, ext in ipairs({ ".bat", ".exe", ".cmd" }) do
                        if vim.fn.executable(cmd .. ext) == 1 then return vim.fn.exepath(cmd .. ext) end
                    end
                end
                return nil
            end

            -- LSP configuration for your main languages

            -- 1. Lua LSP (for Neovim configuration)
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

            -- 2. Dart LSP (robust configuration with error handling)
            local flutter_home = os.getenv("FLUTTER_HOME")
                or (vim.fn.expand("$HOME") .. sep .. "development" .. sep .. "flutter")
            local dart_path = find_exe("dart")
                or (flutter_home .. sep .. "bin" .. sep .. (is_win and "dart.bat" or "dart"))
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
                        onlyAnalyzeProjectsWithOpenFiles = true, -- More conservative
                        suggestFromUnimportedLibraries = true,
                        closingLabels = true,
                        outline = true,
                        flutterOutline = false,
                    },
                    settings = {
                        dart = {
                            completeFunctionCalls = true,
                            showTodos = false, -- Disabled to reduce load
                            enableSnippets = true,
                            updateImportsOnRename = true,
                            lineLength = 80,
                        }
                    },
                    on_attach = function(client, bufnr)
                        -- Dart-specific configuration
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

            -- 3. C/C++ LSP (main language)
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

            -- 4. Swift LSP (macOS only - sourcekit-lsp comes with Xcode)
            if is_mac and vim.fn.executable("sourcekit-lsp") == 1 then
                lspconfig.sourcekit.setup({
                    capabilities = capabilities,
                    cmd = { "sourcekit-lsp" },
                    filetypes = { "swift" },
                })
            end

            -- 5. Kotlin LSP (main language)
            if vim.fn.executable("kotlin-language-server") == 1 then
                lspconfig.kotlin_language_server.setup({
                    capabilities = capabilities,
                    cmd = { "kotlin-language-server" },
                    filetypes = { "kotlin" },
                    root_dir = lspconfig.util.root_pattern("settings.gradle.kts", "settings.gradle", "build.gradle.kts", "build.gradle"),
                })
            end

            -- 6. JSON LSP (configurations)
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

            -- 7. YAML LSP (Flutter/Android configurations)
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

            -- ============================================
            -- NEW LSP SYSTEM: No duplicates, no uppercase
            -- ============================================
            -- NOTE: Main commands WITHOUT leader (faster):
            --   gd = goto definition
            --   gi = goto implementation  
            --   gr = goto references
            --   K  = hover documentation
            -- These are automatically configured by nvim-lspconfig
            
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    local opts = { buffer = ev.buf, silent = true }

                    -- Code Actions & Refactoring
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename Symbol" }))
                    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code Action" }))

                    -- Navigation (synced with .ideavimrc)
                    vim.keymap.set("n", "go", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Go to Type Definition" }))
                    vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature Help / Parameter Info" }))

                    -- Format
                    vim.keymap.set("n", "<leader>fm", function()
                        vim.lsp.buf.format { async = true }
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
                    source = "always",
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

            -- Optimization: Reduce LSP logging for better performance
            vim.lsp.set_log_level("WARN")
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
            automatic_installation = true,
        },
    },

    -- LSP progress indicator (shows loading/indexing status)
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