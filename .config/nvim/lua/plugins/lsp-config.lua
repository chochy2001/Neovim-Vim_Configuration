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
            -- Only enable servers whose binary was actually configured, so
            -- vim.lsp.enable() never tries to start a missing server (all OS).
            local enabled = {}

            -- 1. Lua LSP (for Neovim configuration)
            -- Install with `:MasonInstall lua-language-server`
            if vim.fn.executable("lua-language-server") == 1 then
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
                table.insert(enabled, "lua_ls")
            end

            -- 2. Dart LSP is owned by flutter-tools.nvim (outline, widget
            -- guides, closing labels). Do NOT vim.lsp.enable("dartls") here:
            -- flutter-tools always vim.lsp.start()s dartls, and a second
            -- client races with fix-flutter-neotree-conflict.lua.

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
                        "--function-arg-placeholders=1",
                    },
                    filetypes = { "c", "cpp", "objc", "objcpp" },
                })
                table.insert(enabled, "clangd")
            end

            -- 4. Swift LSP (macOS only)
            if is_mac and vim.fn.executable("sourcekit-lsp") == 1 then
                vim.lsp.config("sourcekit", {
                    capabilities = capabilities,
                    cmd = { "sourcekit-lsp" },
                    filetypes = { "swift" },
                })
                table.insert(enabled, "sourcekit")
            end

            -- 5. Kotlin LSP
            if vim.fn.executable("kotlin-language-server") == 1 then
                vim.lsp.config("kotlin_language_server", {
                    capabilities = capabilities,
                    cmd = { "kotlin-language-server" },
                    filetypes = { "kotlin" },
                    root_markers = { "settings.gradle.kts", "settings.gradle", "build.gradle.kts", "build.gradle" },
                })
                table.insert(enabled, "kotlin_language_server")
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
                table.insert(enabled, "jsonls")
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
                table.insert(enabled, "yamlls")
            end

            -- 8. Go LSP (10 backend repos; install: `:MasonInstall gopls`)
            if vim.fn.executable("gopls") == 1 then
                vim.lsp.config("gopls", {
                    capabilities = capabilities,
                    cmd = { "gopls" },
                    filetypes = { "go", "gomod", "gowork", "gotmpl" },
                    root_markers = { "go.mod", "go.work", ".git" },
                    settings = {
                        gopls = {
                            analyses = { unusedparams = true, shadow = true },
                            staticcheck = true,
                            gofumpt = true,
                        },
                    },
                })
                table.insert(enabled, "gopls")
            end

            -- 9. Python LSP (install: `:MasonInstall pyright`)
            if vim.fn.executable("pyright-langserver") == 1 or vim.fn.executable("pyright") == 1 then
                vim.lsp.config("pyright", {
                    capabilities = capabilities,
                    filetypes = { "python" },
                    root_markers = {
                        "pyproject.toml",
                        "setup.py",
                        "setup.cfg",
                        "requirements.txt",
                        "Pipfile",
                        ".git",
                    },
                    settings = {
                        python = {
                            analysis = {
                                autoSearchPaths = true,
                                useLibraryCodeForTypes = true,
                                diagnosticMode = "openFilesOnly",
                            },
                        },
                    },
                })
                table.insert(enabled, "pyright")
            end

            -- 10. TypeScript/JavaScript LSP (install: `:MasonInstall vtsls`)
            if vim.fn.executable("vtsls") == 1 then
                vim.lsp.config("vtsls", {
                    capabilities = capabilities,
                    filetypes = {
                        "javascript",
                        "javascriptreact",
                        "typescript",
                        "typescriptreact",
                    },
                    root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
                })
                table.insert(enabled, "vtsls")
            end

            -- 11. Astro LSP for the Astro landings
            -- (install: `:MasonInstall astro-language-server`)
            -- NOTE: cmd is pinned to Mason's copy on purpose. lspconfig's
            -- default prefers `<root>/node_modules/.bin/astro-ls`, which
            -- crashes when a project's tree is incomplete (seen live:
            -- missing `ajv/dist/core`); Mason's copy always works.
            local astro_mason = vim.fn.stdpath("data")
                .. "/mason/bin/astro-ls"
                .. (is_win and ".cmd" or "")
            if vim.fn.executable(astro_mason) == 1 or vim.fn.executable("astro-ls") == 1 then
                vim.lsp.config("astro", {
                    capabilities = capabilities,
                    cmd = vim.fn.executable(astro_mason) == 1
                            and { astro_mason, "--stdio" }
                        or { "astro-ls", "--stdio" },
                    filetypes = { "astro" },
                    root_markers = { "package.json", "astro.config.mjs", "astro.config.mts", ".git" },
                })
                table.insert(enabled, "astro")
            end

            -- 12. PHP LSP for CapMenu / Opus / Inventario QR backends
            -- (install: `:MasonInstall intelephense`)
            if vim.fn.executable("intelephense") == 1 then
                vim.lsp.config("intelephense", {
                    capabilities = capabilities,
                    cmd = { "intelephense", "--stdio" },
                    filetypes = { "php" },
                    root_markers = { "composer.json", ".git" },
                })
                table.insert(enabled, "intelephense")
            end

            -- 13. Bash (hundreds of .sh scripts in the fleet)
            if vim.fn.executable("bash-language-server") == 1 then
                vim.lsp.config("bashls", {
                    capabilities = capabilities,
                    cmd = { "bash-language-server", "start" },
                    filetypes = { "sh", "bash" },
                    settings = {
                        -- Don't warn when shellcheck isn't installed
                        bashIde = { shellcheckPath = "" },
                    },
                })
                table.insert(enabled, "bashls")
            end

            -- 14. Dockerfile
            if vim.fn.executable("docker-langserver") == 1 then
                vim.lsp.config("dockerls", {
                    capabilities = capabilities,
                    cmd = { "docker-langserver", "--stdio" },
                    filetypes = { "dockerfile" },
                    root_markers = { "Dockerfile", ".git" },
                })
                table.insert(enabled, "dockerls")
            end

            -- 15. HTML / CSS (landings + Flutter web)
            if vim.fn.executable("vscode-html-language-server") == 1 then
                vim.lsp.config("html", {
                    capabilities = capabilities,
                    cmd = { "vscode-html-language-server", "--stdio" },
                    filetypes = { "html" },
                    -- Embedded CSS lint in vscode-html crashes on some
                    -- Flutter web index.html files (validProperties null).
                    settings = {
                        html = { validate = { scripts = true, styles = false } },
                    },
                })
                table.insert(enabled, "html")
            end
            if vim.fn.executable("vscode-css-language-server") == 1 then
                vim.lsp.config("cssls", {
                    capabilities = capabilities,
                    cmd = { "vscode-css-language-server", "--stdio" },
                    filetypes = { "css", "scss", "less" },
                })
                table.insert(enabled, "cssls")
            end

            -- 16. TOML (Cargo.toml, pyproject, many lock-adjacent configs)
            if vim.fn.executable("taplo") == 1 then
                vim.lsp.config("taplo", {
                    capabilities = capabilities,
                    cmd = { "taplo", "lsp", "stdio" },
                    filetypes = { "toml" },
                })
                table.insert(enabled, "taplo")
            end

            -- Enable only the servers configured above
            vim.lsp.enable(enabled)

            -- LSP keymaps on attach
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    local opts = { buffer = ev.buf, silent = true }

                    -- Code Actions & Refactoring
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename Symbol" }))
                    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code Action" }))

                    -- Navigation (docs/WORKFLOW/IdeaVim: gd/gi — not 0.12 CTRL-] / gri)
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to Definition" }))
                    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to Implementation" }))
                    vim.keymap.set("n", "go", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Go to Type Definition" }))
                    vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature Help" }))

                    vim.keymap.set("n", "<leader>fm", function()
                        local bufnr = ev.buf
                        local ft = vim.bo[bufnr].filetype
                        local null_formats = false
                        local ok_nl, nl = pcall(require, "null-ls")
                        if ok_nl then
                            local ok_src, src = pcall(require, "null-ls.sources")
                            if ok_src and src.get_available then
                                local avail = src.get_available(ft, nl.methods.FORMATTING) or {}
                                null_formats = #avail > 0
                            end
                        end
                        vim.lsp.buf.format({
                            bufnr = bufnr,
                            async = true,
                            filter = function(c)
                                if null_formats then
                                    return c.name == "null-ls"
                                end
                                return c.name ~= "null-ls"
                            end,
                        })
                    end, vim.tbl_extend("force", opts, { desc = "Format document" }))
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
    -- NOTE (2026): upstream moved williamboman/* -> mason-org/* (v2.x, active)
    {
        "mason-org/mason.nvim",
        -- All commands registered so lazy loads mason on any of them
        -- (including headless `:MasonInstall <pkg>` usage)
        cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonUpdate", "MasonLog" },
        build = ":MasonUpdate",
        opts = {
            ui = { border = "rounded" },
        },
    },
    {
        "mason-org/mason-lspconfig.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
        opts = {
            ensure_installed = {
                "lua_ls",
                "clangd",
                "jsonls",
                "yamlls",
                "gopls",
                "pyright",
                "vtsls",
                "astro",
                "intelephense",
                "bashls",
                "dockerls",
                "html",
                "cssls",
                "taplo",
            },
            -- stylua ships an LSP mode but formatting is already covered
            -- by none-ls: avoid duplicate formatting clients
            automatic_enable = { exclude = { "stylua", "dartls" } },
        },
    },

    -- Auto-install formatters/linters on startup (community standard
    -- companion to mason-lspconfig, which only covers LSP servers)
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        event = "VeryLazy",
        dependencies = { "mason-org/mason.nvim" },
        opts = {
            ensure_installed = {
                "lua-language-server",
                "stylua",
                "prettier",
                -- NOTE: no "black"/"clang-format": Mason needs `python3` on
                -- PATH (absent on stock Windows with Store Python).
                -- Provision them with `uv tool install black clang-format`
                -- instead; none-ls picks them up from PATH.
            },
            auto_update = false,
            run_on_start = true,
            start_delay = 3000,
            debounce_hours = 24,
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
