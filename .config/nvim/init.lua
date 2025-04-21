--Establecer el líder de teclas
vim.g.mapleader = " "

-- Cargar configuraciones
require("plugins")
require("settings")
require("keymaps")
require("lsp")
require("plugin.colors")
require("plugin.harpoon")
require("plugin.undotree")
require("mappings")

-- vim.cmd("set expandtab") -- Convertir tabulaciones en espacios
-- vim.cmd("set tabstop=2") -- Número de espacios que representa una tabulación
-- vim.cmd("set shiftwidth=2") -- Número de espacios para la indentación
--
-- -- Bootstrap lazy.nv
-- local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- if not (vim.uv or vim.loop).fs_stat(lazypath) then
-- 	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
-- 	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
-- 	if vim.v.shell_error ~= 0 then
-- 		vim.api.nvim_echo({
-- 			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
-- 			{ out, "WarningMsg" },
-- 			{ "\nPress any key to exit..." },
-- 		}, true, {})
-- 		vim.fn.getchar()
-- 		os.exit(1)
-- 	end
-- end
-- vim.opt.rtp:prepend(lazypath)
-- local plugins = {}
-- local opts = {}
--
-- require("lazy").setup(plugins, opts)
