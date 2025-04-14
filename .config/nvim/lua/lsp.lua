-- Configuración de Mason
require("mason").setup()

-- Configuración de Mason LSPConfig
require("mason-lspconfig").setup({
	ensure_installed = {
		"pyright",
		"html",
		"cssls",
		"bashls",
		"jsonls",
		"yamlls",
		"lua_ls",
		"marksman",
		"clangd",
		"rust_analyzer",
		"texlab",
	},
	automatic_installation = true,
})

-- Carga segura de lspconfig
local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
	vim.notify("No se pudo cargar lspconfig", vim.log.levels.ERROR)
	return
end

-- Configuración por servidor
local servers = {
	pyright = {},
	html = {},
	cssls = {},
	bashls = {},
	jsonls = {},
	yamlls = {},
	lua_ls = {
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" },
				},
			},
		},
	},
	marksman = {},
	clangd = {},
	rust_analyzer = {},
	texlab = {},
}

-- Integración de autocompletado con cmp y LuaSnip
local cmp_status, cmp = pcall(require, "cmp")
if not cmp_status then
	vim.notify("nvim-cmp no se pudo cargar", vim.log.levels.ERROR)
	return
end

local luasnip = require("luasnip")

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping.select_next_item(),
		["<S-Tab>"] = cmp.mapping.select_prev_item(),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	}),
})

-- Solo se usa para pasar al setup del servidor, sin duplicar keymaps
local capabilities = require("cmp_nvim_lsp").default_capabilities()

for server, config in pairs(servers) do
	local has_server = lspconfig[server]
	if has_server and type(has_server.setup) == "function" then
		config.capabilities = capabilities
		has_server.setup(config)
	else
		vim.notify("No se pudo cargar el LSP: " .. server, vim.log.levels.WARN)
	end
end
