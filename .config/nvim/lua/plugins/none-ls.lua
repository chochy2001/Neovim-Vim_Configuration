-- Configuración simplificada de none-ls que funciona inmediatamente
return {
	"nvimtools/none-ls.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting
		local diagnostics = null_ls.builtins.diagnostics
		local code_actions = null_ls.builtins.code_actions

		null_ls.setup({
			debounce = 150,
			debug = false,
			-- Solo herramientas básicas que generalmente están disponibles
			sources = {
				-- === FORMATEADORES BÁSICOS ===

				-- C/C++ - clang-format (viene con Xcode)
				formatting.clang_format.with({
					extra_args = {
						"--style={BasedOnStyle: llvm, IndentWidth: 4, ColumnLimit: 100}",
					},
					filetypes = { "c", "cpp", "objc", "objcpp" },
				}),

				-- Dart/Flutter - dart format (viene con Flutter SDK)
				formatting.dart_format,

				-- Lua - stylua (instalar con Mason)
				formatting.stylua.with({
					extra_args = { "--indent-type", "Spaces", "--indent-width", "4" },
				}),

				-- Web technologies - prettier (instalar con Mason)
				-- NOTA: Usar configuración global. Para usar .prettierrc del proyecto,
				-- comentar extra_args y prettier respetará archivos de configuración locales
				formatting.prettier.with({
					extra_filetypes = { "toml" },
					extra_args = {
						"--tab-width", "2",
						"--semi", "true",
						"--single-quote", "false",
						"--trailing-comma", "es5"
					},
					-- Alternativa: Sin extra_args permite que .prettierrc controle el formateo
					-- extra_args = {},
				}),

				-- Git code actions (siempre disponible)
				code_actions.gitsigns,
			},

			-- Configuración conservadora para formatear al guardar
			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					-- Solo auto-formatear archivos seguros
					local safe_auto_format = {
						"lua", "dart", "json"
					}

					local filetype = vim.bo[bufnr].filetype
					if vim.tbl_contains(safe_auto_format, filetype) then
						local format_augroup = vim.api.nvim_create_augroup("SafeAutoFormat_" .. bufnr, { clear = true })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = format_augroup,
							buffer = bufnr,
							callback = function()
								-- Timeout corto para evitar bloqueos
								pcall(function()
									vim.lsp.buf.format({
										bufnr = bufnr,
										timeout_ms = 1000,
										filter = function(client)
											return client.name == "null-ls"
										end
									})
								end)
							end,
						})
					end
				end

				-- Keymaps seguros del buffer
				local opts = { buffer = bufnr, silent = true }
				-- CONFLICTO RESUELTO: Quitado <leader>f para evitar conflicto con LSP
				-- LSP mantiene <leader>f, none-ls usa <leader>ff solamente
				-- vim.keymap.set("n", "<leader>f", function()
				-- 	pcall(function()
				-- 		vim.lsp.buf.format({
				-- 			bufnr = bufnr,
				-- 			timeout_ms = 1500,
				-- 			async = false
				-- 		})
				-- 	end)
				-- end, vim.tbl_extend("force", opts, { desc = "Format Buffer (Safe)" }))
			end,

			-- Configuración de seguridad
			should_attach = function(bufnr)
				-- No adjuntar a buffers muy grandes
				local max_filesize = 50 * 1024 -- 50 KB
				local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
				if ok and stats and stats.size > max_filesize then
					return false
				end

				-- No adjuntar a tipos de archivo problemáticos
				local excluded_filetypes = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" }
				if vim.tbl_contains(excluded_filetypes, vim.bo[bufnr].filetype) then
					return false
				end

				return true
			end,

			update_in_insert = false,
		})

		-- Keymaps globales seguros (sincronizado con LSP <leader>lf)
		vim.keymap.set("n", "<leader>lf", function()
			pcall(function()
				vim.lsp.buf.format({ timeout_ms = 1500 })
			end)
		end, { desc = "LSP: Format Buffer (Safe)" })

		-- Comando para verificar herramientas disponibles
		vim.api.nvim_create_user_command("CheckFormatters", function()
			local available = {}
			local sources = null_ls.get_sources()

			for _, source in ipairs(sources) do
				if source.name then
					table.insert(available, source.name)
				end
			end

			if #available > 0 then
				vim.notify("Available formatters: " .. table.concat(available, ", "), vim.log.levels.INFO)
			else
				vim.notify("No formatters currently loaded", vim.log.levels.WARN)
			end
		end, { desc = "Check available formatters" })
	end,
}