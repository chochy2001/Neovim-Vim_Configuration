-- lua/lsp.lua -- VERSIÓN FINAL OPTIMIZADA

-- Configuración de Mason
require("mason").setup() -- Configuración básica

-- Configuración de Mason LSPConfig
require("mason-lspconfig").setup({
	-- Lista de servidores LSP que quieres que Mason asegure que estén instalados
	-- Usa los nombres EXACTOS de Mason aquí
	ensure_installed = {
		"bashls", -- Nombre para bash-language-server
		"cssls", -- Nombre para css-lsp
		"dockerls", -- Nombre para dockerfile-language-server
		"gopls",
		"html", -- Nombre para html-lsp
		"jdtls",
		"jsonls", -- Nombre para json-lsp
		"kotlin_language_server", -- Nombre para kotlin-language-server
		"lua_ls", -- Nombre para lua-language-server
		"sqlls",
		"yamlls", -- Nombre para yaml-language-server
	},
})

vim.opt.signcolumn = "yes" -- Para mostrar iconos de diagnóstico LSP

-- Carga segura de lspconfig
local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
	vim.notify("No se pudo cargar lspconfig", vim.log.levels.ERROR)
	return
end

-- Añadir capacidades de cmp_nvim_lsp a los defaults de lspconfig
local lspconfig_defaults = lspconfig.util.default_config
lspconfig_defaults.capabilities =
	vim.tbl_deep_extend("force", lspconfig_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

-- Tabla FINAL de servidores a configurar por lspconfig
-- Usa los nombres que lspconfig espera (a veces alias)
local servers = {
	-- Backend & Mobile
	gopls = {},
	jdtls = {},
	kotlin_language_server = {}, -- lspconfig usa este nombre
	dartls = {}, -- lspconfig usa este nombre (del SDK)
	-- sourcekit_lsp = {},       -- Swift (Descomentar tras instalar)

	-- SQL & Docker
	sqlls = {},
	dockerls = {}, -- lspconfig usa este nombre

	-- Web & Comunes
	html = {}, -- lspconfig usa 'html'
	cssls = {}, -- lspconfig usa 'cssls'
	jsonls = {}, -- lspconfig usa 'jsonls'
	yamlls = {}, -- lspconfig usa 'yamlls'
	bashls = {}, -- lspconfig usa 'bashls'

	-- Configuración Neovim
	lua_ls = { -- lspconfig usa 'lua_ls'
		settings = {
			Lua = {
				diagnostics = { globals = { "vim" } },
			},
		},
	},
}

-- Integración de autocompletado con cmp y LuaSnip (Tu código está bien)
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

-- Función on_attach (Tu código con los keymaps está bien)
local on_attach = function(client, bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }
	print("LSP Client attached: " .. client.name .. " to buffer " .. bufnr)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
	vim.keymap.set({ "n", "x" }, "<F3>", function()
		vim.lsp.buf.format({ async = true })
	end, opts)
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
end

-- Bucle final CORREGIDO para configurar los servidores listados en la tabla 'servers'
for server, config in pairs(servers) do
	-- Obtén el objeto de configuración específico del servidor desde la tabla lspconfig ya cargada
	local server_config = lspconfig[server] -- Busca la configuración para el nombre del servidor actual

	-- Verifica si lspconfig reconoce este servidor y si tiene una función 'setup'
	if server_config and type(server_config.setup) == "function" then
		-- Asigna tu función on_attach personalizada a la configuración del servidor
		config.on_attach = on_attach
		-- Las capabilities ya se establecieron globalmente, no es necesario pasarlas aquí usualmente.
		-- Llama a la función setup del servidor específico, pasando la tabla 'config'
		-- (que ahora incluye tu on_attach y cualquier otra configuración de tu tabla 'servers')
		server_config.setup(config)
		print("LSP Configured: " .. server) -- Mensaje opcional para confirmar configuración
	else
		-- Notifica si el nombre del servidor en tu tabla 'servers' no fue encontrado en lspconfig
		vim.notify(
			"LSP server '" .. server .. "' no encontrado en lspconfig o no tiene función setup.",
			vim.log.levels.WARN
		)
	end
end
