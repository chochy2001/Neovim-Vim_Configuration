return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
		-- Opcional: '3rd/image.nvim' si quieres previsualización de imágenes
	},
	config = function()
		-- Mantén tus mapeos de teclas
		vim.keymap.set("n", "<leader>pv", ":Neotree filesystem reveal left<CR>", {}) -- Cambiado para que sea más específico
		vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", {})

		-- Configura Neo-tree
		require("neo-tree").setup({
			-- Puedes añadir otras opciones generales aquí si quieres
			close_if_last_window = true, -- Buena opción para cerrar neotree automáticamente

			filesystem = {
				-- Opciones específicas para la vista del sistema de archivos
				filtered_items = {
					visible = true, -- Asegúrate de que la lógica de filtrado esté activa (es el valor por defecto)
					-- =====> ESTA ES LA OPCIÓN CLAVE <=====
					hide_dotfiles = false, -- Cambia a 'false' para MOSTRAR archivos/directorios ocultos (que empiezan por '.')
					-- =====> ESTA ES LA OPCIÓN CLAVE <=====
					hide_gitignored = true, -- Puedes mantener esto en 'true' si quieres seguir ocultando archivos de .gitignore
					hide_hidden = false, -- Similar a hide_dotfiles, asegúrate de que esté en false.
					-- never_show = { ".DS_Store", "thumbs.db" }, -- Opcional: lista de archivos que NUNCA quieres ver
				},
				follow_current_file = { -- Opcional: útil para que Neotree siga al archivo activo
					enabled = true,
				},
				-- Puedes añadir más configuraciones de filesystem aquí...
			},
			window = {
				-- Configuraciones de la ventana de Neotree
				mappings = {
					["h"] = "parent_or_close_node", -- Cambiado para que 'h' cierre el nodo o suba al padre
					["l"] = "child_or_open", -- Cambiado para que 'l' abra el nodo o entre en el directorio
				},
			},
			-- Puedes configurar otras fuentes como 'buffers', 'git_status' aquí si las usas
		})

		print("Neo-tree configurado para mostrar archivos ocultos.") -- Mensaje de confirmación opcional
	end,
}
