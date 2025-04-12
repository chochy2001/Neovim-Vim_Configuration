--Establecer el líder de teclas
vim.g.mapleader = ' '

-- Cargar configuraciones
require('plugins')
require('settings')
require('keymaps')
require('lsp')
require('plugin.colors')
require('plugin.treesitter')
require('plugin.harpoon')
require('plugin.undotree')
require('mappings')

