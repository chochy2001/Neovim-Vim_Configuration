local null_ls = require("null-ls")

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

-- Grupo de autocomandos
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
	sources = {
		-- FORMATTERS
		formatting.gofmt,
		formatting.golines,
		formatting.ktlint,
		formatting.google_java_format,
		formatting.dart_format,
		formatting.clang_format.with({
			filetypes = { "java", "xml" },
		}),
		formatting.stylua,

		-- Swift usando stdin para evitar conflictos de escritura
		formatting.swift_format.with({
			command = "swift-format",
			args = {
				"--assume-filename",
				"$FILENAME",
			},
			to_stdin = true,
		}),

		-- LINTERS
		diagnostics.golangci_lint,
		diagnostics.ktlint,
	},

	-- Formateo al guardar
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr })
				end,
			})
		end
	end,
})
