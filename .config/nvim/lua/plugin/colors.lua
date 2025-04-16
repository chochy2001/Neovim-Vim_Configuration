function ColorMyPencils(color)
	color = color or "dracula"
	vim.cmd.colorscheme(color)

	-- es para hacer el fondo transparente
	-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorMyPencils()
