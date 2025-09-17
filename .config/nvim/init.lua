local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Core fixes - solo los necesarios tras limpieza
pcall(require, "fix-flutter-neotree-conflict")  -- Fix para conflicto flutter-tools + neo-tree
pcall(require, "lsp-utils")                      -- Utilidades LSP y manejo de errores

require("vim-options")
require("lazy").setup("plugins")
