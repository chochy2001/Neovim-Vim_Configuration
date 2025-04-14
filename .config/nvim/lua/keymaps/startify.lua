require("dashboard").setup({
	-- Solo cuando se esté en el buffer del dashboard
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "dashboard",
		callback = function()
			local map = vim.api.nvim_buf_set_keymap
			local opts = { noremap = true, silent = true, nowait = true }

			-- Vincula las teclas 1-9 a las acciones
			map(0, "n", "1", ":Telescope find_files<CR>", opts)
			map(0, "n", "2", ":Telescope live_grep<CR>", opts)
			map(0, "n", "3", ":Telescope oldfiles<CR>", opts)
			map(0, "n", "4", ":Neotree toggle<CR>", opts)
			map(0, "n", "5", ":ToggleTerm<CR>", opts)
			map(0, "n", "6", ":edit ~/.config/nvim/lua/plugins.lua<CR>", opts)
			map(0, "n", "7", ":PackerSync<CR>", opts)
			map(0, "n", "8", ":Mason<CR>", opts)
		end,
	}),

	theme = "doom",
	config = {
		header = {
			[[  ______                             __                      __           ]],
			[[ /      \                           |  \                    |  \          ]],
			[[|  $$$$$$\  ______    ______    ____| $$  ______    _______  \$$  _______ ]],
			[[| $$   \$$ |      \  /      \  /      $$ /      \  /       \|  \ /       \]],
			[[| $$        \$$$$$$\|  $$$$$$\|  $$$$$$$|  $$$$$$\|  $$$$$$$| $$|  $$$$$$$]],
			[[| $$   __  /      $$| $$  | $$| $$  | $$| $$    $$ \$$    \ | $$ \$$    \ ]],
			[[| $$__/  \|  $$$$$$$| $$__/ $$| $$__| $$| $$$$$$$$ _\$$$$$$\| $$ _\$$$$$$\ ]],
			[[ \$$    $$ \$$    $$| $$    $$ \$$    $$ \$$     \|       $$| $$|       $$]],
			[[  \$$$$$$   \$$$$$$$| $$$$$$$   \$$$$$$$  \$$$$$$$ \$$$$$$$  \$$ \$$$$$$$ ]],
			[[                    | $$                                                  ]],
			[[                    | $$                                                  ]],
			[[                     \$$                                                  ]],
		},
		center = {
			{ icon = "1️⃣ ", desc = " Find File             ", action = "Telescope find_files" },
			{ icon = "2️⃣ ", desc = " Find Word             ", action = "Telescope live_grep" },
			{ icon = "3️⃣ ", desc = " Recent Files          ", action = "Telescope oldfiles" },
			{ icon = "4️⃣ ", desc = " File Explorer         ", action = "Neotree toggle" },
			{ icon = "5️⃣ ", desc = " Toggle Terminal       ", action = "ToggleTerm" },
			{ icon = "6️⃣ ", desc = " Edit Config           ", action = "edit ~/.config/nvim/lua/plugins.lua" },
			{ icon = "7️⃣ ", desc = " Plugin Sync (Packer)  ", action = "PackerSync" },
			{ icon = "8️⃣ ", desc = " LSP Installer (Mason) ", action = "Mason" },
		},
		footer = { "🚀  Que el código te acompañe, Chochy 🧠" },
	},
})
