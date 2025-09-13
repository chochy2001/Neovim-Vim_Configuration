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

-- Deshabilitar Mason antes de cargar plugins
require("disable-mason")

-- Silenciar TODOS los warnings de deprecación
require("silence-all-deprecations")

-- Supresor ULTRA AGRESIVO de errores E5248
require("error-suppressor")

-- Arreglar APIs deprecadas
require("fix-deprecated-apis")

-- Solucionar conflictos LSP
require("fix-lsp-conflicts")

require("vim-options")
require("lazy").setup("plugins")
