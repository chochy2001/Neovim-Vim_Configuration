return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	cmd = "Neotree",
	keys = {
		{ "<leader>pv", "<cmd>Neotree filesystem toggle<cr>", desc = "Toggle NeoTree filesystem" },
		{ "<leader>bf", "<cmd>Neotree buffers reveal float<cr>", desc = "NeoTree buffers" },
		-- IntelliJ-like navigation between tree and editor
		{ "<C-S-o>", "<cmd>Neotree filesystem reveal<cr>", desc = "Reveal current file in tree" },
		{ "<leader>pf", "<cmd>Neotree filesystem focus<cr>", desc = "Focus NeoTree" },
	},
	config = function()
		-- Configuración con manejo de errores
		vim.g.neo_tree_remove_legacy_commands = 1
		local status_ok, neo_tree = pcall(require, "neo-tree")
		if not status_ok then
			vim.notify("Neo-tree no se pudo cargar", vim.log.levels.ERROR)
			return
		end

		-- Asegurar que nvim-web-devicons esté disponible
		local web_devicons_ok, web_devicons = pcall(require, "nvim-web-devicons")
		if not web_devicons_ok then
			vim.notify("nvim-web-devicons no está disponible", vim.log.levels.WARN)
		end

		neo_tree.setup({
			close_if_last_window = true,
			popup_border_style = "rounded",
			enable_git_status = true,
			enable_diagnostics = true,
			use_popups_for_input = false,

			-- Configuración segura del filesystem
			filesystem = {
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_hidden = false,
					never_show = { ".DS_Store", "thumbs.db" },
				},
				follow_current_file = {
					enabled = true,
					leave_dirs_open = false,
				},
				group_empty_dirs = false,
				hijack_netrw_behavior = "open_default",
				use_libuv_file_watcher = false, -- Deshabilitado para evitar errores
			},

			-- Configuración segura de la ventana
			window = {
				position = "left",
				width = 30,
				mapping_options = {
					noremap = true,
					nowait = true,
				},
				mappings = {
					["<space>"] = {
						"toggle_node",
						nowait = false,
					},
					["<2-LeftMouse>"] = "open",
					["<cr>"] = "open",
					["<esc>"] = "cancel",
					-- IntelliJ-like navigation
					["<C-l>"] = "focus_preview", -- Focus back to editor
					["o"] = "open",
					["P"] = { "toggle_preview", config = { use_float = true } },
					["l"] = "focus_preview",
					["S"] = "open_split",
					["s"] = "open_vsplit",
					["t"] = "open_tabnew",
					["w"] = "open_with_window_picker",
					["C"] = "close_node",
					["z"] = "close_all_nodes",
					["a"] = {
						"add",
						config = {
							show_path = "none"
						}
					},
					["A"] = "add_directory",
					["d"] = "delete",
					["r"] = "rename",
					["y"] = "copy_to_clipboard",
					["x"] = "cut_to_clipboard",
					["p"] = "paste_from_clipboard",
					["c"] = "copy",
					["m"] = "move",
					["q"] = "close_window",
					["R"] = "refresh",
					["?"] = "show_help",
					["<"] = "prev_source",
					[">"] = "next_source",
					["i"] = "show_file_details",
				}
			},

			-- Configuración por defecto ROBUSTA
			default_component_configs = {
				container = {
					enable_character_fade = true
				},
				indent = {
					indent_size = 2,
					padding = 1,
					with_markers = true,
					indent_marker = "│",
					last_indent_marker = "└",
					highlight = "NeoTreeIndentMarker",
					with_expanders = nil,
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
				icon = {
					folder_closed = "",
					folder_open = "",
					folder_empty = "󰜌",
					folder_empty_open = "󰜌",
					-- ICONO POR DEFECTO OBLIGATORIO - nunca vacío
					default = "",
					highlight = "NeoTreeFileIcon"
				},
				modified = {
					symbol = "[+]",
					highlight = "NeoTreeModified",
				},
				name = {
					trailing_slash = false,
					use_git_status_colors = true,
					highlight = "NeoTreeFileName",
				},
				git_status = {
					symbols = {
						added     = "+",
						modified  = "~",
						deleted   = "-",
						renamed   = "R",
						untracked = "?",
						ignored   = "!",
						unstaged  = "U",
						staged    = "S",
						conflict  = "C",
					}
				},
			},
		})

		-- Keymaps adicionales para navegación tipo IntelliJ (macOS optimized)
		-- Nota: Optimizado para MacBook Pro con teclado US/Spanish
		vim.keymap.set("n", "<D-1>", "<cmd>Neotree filesystem focus<cr>", { desc = "Focus NeoTree (Cmd+1)" })
		vim.keymap.set("n", "<D-S-1>", "<cmd>Neotree filesystem toggle<cr>", { desc = "Toggle NeoTree (Cmd+Shift+1)" })
		-- Alternativa con Ctrl para usuarios que prefieren Ctrl
		vim.keymap.set("n", "<C-1>", "<cmd>Neotree filesystem focus<cr>", { desc = "Focus NeoTree (Ctrl+1)" })

		-- Keymap para revelar archivo actual en el árbol (macOS optimized)
		vim.keymap.set("n", "<leader>fr", "<cmd>Neotree filesystem reveal<cr>", { desc = "Reveal file in tree" })
		-- Equivalente a Cmd+Shift+O en IntelliJ para macOS
		vim.keymap.set("n", "<D-S-o>", "<cmd>Neotree filesystem reveal<cr>", { desc = "Reveal file (Cmd+Shift+O)" })

		-- Auto-comandos para mejorar la navegación
		vim.api.nvim_create_autocmd("BufEnter", {
			group = vim.api.nvim_create_augroup("NeotreeNavigation", { clear = true }),
			pattern = "*",
			callback = function()
				-- Si estamos en neo-tree, mapear teclas para volver al editor
				if vim.bo.filetype == "neo-tree" then
					vim.keymap.set("n", "<Tab>", "<C-w>l", { buffer = true, desc = "Focus editor" })
					vim.keymap.set("n", "<S-Tab>", "<C-w>h", { buffer = true, desc = "Focus tree" })
				end
			end,
		})

		print("✅ Neo-tree configurado con navegación tipo IntelliJ (macOS optimized)")
	end,
}
