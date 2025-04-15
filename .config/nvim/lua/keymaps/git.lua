-- ~/.config/nvim/lua/keymaps/git.lua
-- VERSION UNIFICADA USANDO vim.keymap.set y CORREGIDA

local opts_noremap_silent = { noremap = true, silent = true } -- Define opciones comunes una vez
local builtin_telescope = require("telescope.builtin")
local wk = require("which-key")

-- Definición de Mapeos (usando vim.keymap.set con 'desc' para que which-key los recoja)
vim.keymap.set("n", "<leader>gl", ":Git log<CR>", { desc = "Git Log (fugitive)", noremap = true, silent = true })
vim.keymap.set("n", "<leader>gc", ":Git commit<CR>", { desc = "Git Commit (fugitive)", noremap = true, silent = true })
vim.keymap.set("n", "<leader>ga", ":Git add %<CR>", { desc = "Git Add File (fugitive)", noremap = true, silent = true })
vim.keymap.set("n", "<leader>gs", ":Git status<CR>", { desc = "Git Status (fugitive)", noremap = true, silent = true })
vim.keymap.set("n", "<leader>gps", ":Git push<CR>", { desc = "Git Push", noremap = true, silent = true })
vim.keymap.set("n", "<leader>gpl", ":Git pull<CR>", { desc = "Git Pull", noremap = true, silent = true })
vim.keymap.set("n", "<leader>gg", ":Neogit<CR>", { desc = "Neogit UI", noremap = true, silent = true })
vim.keymap.set(
	"n",
	"<leader>gC",
	builtin_telescope.git_commits, -- Directamente la función aquí
	{ desc = "Git Commits (Telescope)", noremap = true, silent = true }
)
vim.keymap.set(
	"n",
	"<leader>gb",
	builtin_telescope.git_branches, -- Directamente la función aquí
	{ desc = "Git Branches (Telescope)", noremap = true, silent = true }
)
vim.keymap.set(
	"n",
	"<leader>gS",
	builtin_telescope.git_status, -- Directamente la función aquí
	{ desc = "Git Status (Telescope)", noremap = true, silent = true }
)

-- == Registro con which-key (SIMPLIFICADO) ==
-- Solo registramos los grupos. Los mapeos individuales se recogen automáticamente
-- porque usamos la opción `desc` en `vim.keymap.set` arriba.
wk.register({
	["<leader>g"] = { name = "+Git" }, -- Usando 'name' para grupo es otra forma común
	["<leader>gp"] = { name = "+Push/Pull" },
})
