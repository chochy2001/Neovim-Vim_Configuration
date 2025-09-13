-- lua/plugins/copilot.lua

return {
	"github/copilot.vim",
	-- Puedes cargarlo al inicio o de forma diferida.
	-- 'InsertEnter' es una opción razonable. 'BufEnter' también podría serlo.
	event = { "InsertEnter", "BufEnter" },
	-- O si prefieres que siempre esté disponible al iniciar:
	-- event = "VeryLazy", -- o simplemente no poner 'event' ni 'cmd'

	-- Usamos 'init' para configurar las variables globales ANTES de que el plugin se cargue
	init = function()
		-- Deshabilitar Copilot para ciertos tipos de archivo
		-- Consulta ':help copilot-filetypes' después de instalar para ver la sintaxis exacta
		vim.g.copilot_filetypes = {
			["*"] = true, -- Habilitado para todos por defecto
			-- Ejemplos para deshabilitar:
			-- yaml = false,
			-- markdown = false,
			-- help = false,
			-- gitcommit = false,
			-- gitrebase = false,
			-- hgcommit = false,
			-- svn = false,
			-- cvs = false,
			-- dbout = false,
			["--"] = false, -- Archivos sin extensión
		}

		-- Deshabilitar el mapeo por defecto de <Tab> si interfiere con tus otros plugins
		-- Si pones 1, tendrás que mapear manualmente la aceptación (ver nota abajo)
		-- vim.g.copilot_no_tab_map = 1

		-- Opcional: Especificar la ruta a node si no está en el PATH
		-- vim.g.copilot_node_command = "/ruta/a/tu/node"

		-- Otras opciones de configuración (menos comunes)
		-- vim.g.copilot_proxy = "http://usuario:contraseña@proxy.ejemplo.com:3000"
		-- vim.g.copilot_disable_tls = 1 -- No recomendado
	end,
}
