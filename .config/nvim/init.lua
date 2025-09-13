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

-- Core fixes - consolidated and necessary only
require("disable-mason")          -- Disable Mason in favor of system LSPs
require("silence-all-deprecations") -- Silence specific known deprecation warnings
require("error-suppressor")       -- Intelligent error suppression for E5248
require("fix-lsp-conflicts")      -- Fix LSP conflicts between plugins

require("vim-options")
require("lazy").setup("plugins")
