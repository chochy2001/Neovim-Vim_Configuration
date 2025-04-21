-- Archivo: lua/plugins/none-ls.lua
return {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local null_ls = require("null-ls")
        local formatting = null_ls.builtins.formatting
        local diagnostics = null_ls.builtins.diagnostics

        null_ls.setup({
            debounce = 250,
            -- Fuentes para los lenguajes que usas (¡Instala las herramientas con Mason!)
            sources = {
                -- === Formateadores ===
                -- Lua
                formatting.stylua,
                -- Go (Elige uno o usa gopls)
                formatting.gofmt,
                -- formatting.goimports,
                -- Kotlin
                formatting.ktlint,
                -- Java
                formatting.google_java_format,
                -- Web (JS/TS/HTML/CSS/JSON/YAML/MD...)
                formatting.prettier.with({ -- Configuración extra opcional para prettier
                    -- extra_filetypes = { "toml" },
                    -- extra_args = { "--no-semi", "--single-quote" },
                }),
                -- SQL
                formatting.sqlfluff.with({ -- Configuración extra opcional
                    -- extra_args = { "--dialect", "mysql" },
                }),
                -- C/C++ (Si aplica)
                formatting.clang_format,
                -- Shell (Si aplica)
                -- formatting.shfmt,

                -- === Diagnósticos (Linters) ===
                -- Go (Opcional si usas el LSP)
                diagnostics.golangci_lint,
                -- Docker
                diagnostics.hadolint,
                -- Swift
                diagnostics.swiftlint,
                diagnostics.erb_lint,
                -- JS/TS (Opcional si usas eslint-lsp)
                diagnostics.eslint_d,
            },

            -- Configuración para formatear al guardar
            on_attach = function(client, bufnr)
                if client.supports_method("textDocument/formatting") then
                    local format_augroup = vim.api.nvim_create_augroup("FormatOnSave", { clear = true })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = format_augroup,
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 5000 })
                        end,
                    })
                end
            end,
            -- debug = true, -- Descomenta para logs detallados si algo falla
        })

        vim.keymap.set("n", "<leader>ff", vim.lsp.buf.format, { desc = "Format Buffer" })
    end,
}
