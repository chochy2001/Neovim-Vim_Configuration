-- Simplified none-ls configuration that works immediately
return {
	"nvimtools/none-ls.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting
		local code_actions = null_ls.builtins.code_actions

		null_ls.setup({
			debounce = 150,
			debug = false,
			-- Only basic tools that are generally available
			sources = {
				formatting.clang_format.with({
					condition = function()
						return vim.fn.executable("clang-format") == 1
					end,
					extra_args = {
						"--style={BasedOnStyle: llvm, IndentWidth: 4, ColumnLimit: 100}",
					},
					filetypes = { "c", "cpp", "objc", "objcpp" },
				}),
				formatting.dart_format.with({
					condition = function()
						return vim.fn.executable("dart") == 1
					end,
				}),
				formatting.gofmt.with({
					condition = function()
						return vim.fn.executable("gofmt") == 1
					end,
				}),
				formatting.black.with({
					condition = function()
						return vim.fn.executable("black") == 1
					end,
				}),
				formatting.stylua.with({
					condition = function()
						return vim.fn.executable("stylua") == 1
					end,
					extra_args = { "--indent-type", "Spaces", "--indent-width", "4" },
				}),
				formatting.prettier.with({
					condition = function()
						return vim.fn.executable("prettier") == 1
					end,
					extra_filetypes = { "toml" },
					extra_args = {
						"--tab-width", "2",
						"--semi", "true",
						"--single-quote", "false",
						"--trailing-comma", "es5"
					},
				}),
				code_actions.gitsigns,
			},

			-- Conservative format-on-save configuration
			on_attach = function(client, bufnr)
				if client:supports_method("textDocument/formatting") then
					-- Only auto-format safe files
					local safe_auto_format = {
						"lua", "json"
					}

					local filetype = vim.bo[bufnr].filetype
					if vim.tbl_contains(safe_auto_format, filetype) then
						local format_augroup = vim.api.nvim_create_augroup("SafeAutoFormat_" .. bufnr, { clear = true })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = format_augroup,
							buffer = bufnr,
							callback = function()
								pcall(vim.lsp.buf.format, {
									bufnr = bufnr,
									timeout_ms = 1000,
									name = "null-ls",
								})
							end,
						})
					end
				end

			end,

			-- Safety configuration
			should_attach = function(bufnr)
				-- Do not attach to very large buffers
				local max_filesize = 50 * 1024 -- 50 KB
				local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
				if ok and stats and stats.size > max_filesize then
					return false
				end

				-- Do not attach to problematic filetypes
				local excluded_filetypes = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" }
				if vim.tbl_contains(excluded_filetypes, vim.bo[bufnr].filetype) then
					return false
				end

				return true
			end,

			update_in_insert = false,
		})

		-- Format keybinding is <leader>fm in lsp-config.lua

		-- Command to check available tools
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