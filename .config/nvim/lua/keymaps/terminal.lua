require("toggleterm").setup({
	size = function(term)
		if term.direction == "horizontal" then
			return vim.o.lines * 0.6
		elseif term.direction == "vertical" then
			return vim.o.columns * 0.6
		end
	end,
	-- open_mapping = [[<leader>t]],
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = 2,
	start_in_insert = true,
	insert_mappings = true,
	terminal_mappings = true,
	persist_size = true,
	direction = "float", -- default
	float_opts = {
		border = "curved",
		winblend = 3,
	},
})

-- Atajos útiles
local opts = { noremap = true, silent = true }

-- Esc para salir de modo terminal
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", opts)

-- Abre terminal flotante
vim.keymap.set("n", "<leader>t", "<cmd>ToggleTerm<CR>", opts)

-- Abre terminal horizontal (mitad de pantalla)
vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", opts)

-- Abre terminal vertical (40% de ancho)
vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", opts)

-- Abre terminal en nueva pestaña
vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm direction=tab<CR>", opts)
