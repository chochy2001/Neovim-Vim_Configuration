local fn = vim.fn

-- Auto-instalar Packer si no está instalado
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Instalando Packer... cierra y vuelve a abrir Neovim.")
  vim.cmd([[packadd packer.nvim]])
end

-- Autocomando que recarga Neovim cada vez que se guarda plugins.lua
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Manejo seguro de 'require'
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Configuración de Packer para usar una ventana emergente
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})


-- Lista de plugins

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Gestor de plugins
  use ('nvim-treesitter/nvim-treesitter',{run = 'TSUpdate'})
  use ('nvim-treesitter/playground')
  use "nvim-lua/plenary.nvim" -- don't forget to add this one if you don't have it yet!
use {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    requires = { {"nvim-lua/plenary.nvim"} }
}
use ('mbbill/undotree')

use 'neovim/nvim-lspconfig' -- Configuración para LSPs
use 'hrsh7th/nvim-cmp'      -- Motor de autocompletado
use 'hrsh7th/cmp-nvim-lsp'  -- Fuente de nvim-cmp para LSP


  -- Plugins aquí
  use {
    'iamcco/markdown-preview.nvim',
    run = function() vim.fn['mkdp#util#install']() end,
    ft = 'markdown'
  }
  use 'simrat39/symbols-outline.nvim'
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'
  use 'nvim-tree/nvim-web-devicons'
  use 'nvim-tree/nvim-tree.lua'
  use 'nvim-telescope/telescope.nvim'
  use 'nvim-telescope/telescope-ui-select.nvim'
  use 'rcarriga/nvim-notify'
  use 'stevearc/dressing.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'nvim-telescope/telescope-file-browser.nvim'
  use 'williamboman/mason.nvim'
  use 'nvim-lualine/lualine.nvim'
  use 'lewis6991/gitsigns.nvim'
  use 'folke/which-key.nvim'
  use 'akinsho/flutter-tools.nvim'
  use 'mhinz/vim-startify'
  use 'voldikss/vim-floaterm'
  use {
    'junegunn/fzf',
    run = function() vim.fn['fzf#install']() end
  }
  use { 'rose-pine/neovim', as = 'rose-pine' }
  use 'junegunn/fzf.vim'
  use 'jiangmiao/auto-pairs'
  use 'vim-airline/vim-airline'
  use 'vim-airline/vim-airline-themes'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-commentary'
  use 'tpope/vim-surround'
 
  -- Temas y colores
  use { 'dracula/vim', as = 'dracula' }
  use 'tomasr/molokai'
  use 'altercation/vim-colors-solarized'
  use 'joshdick/onedark.vim'
  use 'morhetz/gruvbox'

  -- Otros complementos útiles
  use 'preservim/tagbar'
  use 'luochen1990/rainbow'
  use 'airblade/vim-gitgutter'
  use 'easymotion/vim-easymotion'
  use 'scrooloose/nerdcommenter'
  use 'Yggdroot/indentLine'

  -- Lenguajes específicos
  use 'artur-shaik/vim-javacomplete2'
  use 'ray-x/go.nvim'
  use 'olexsmir/gopher.nvim'
  use 'nvim-lua/lsp-status.nvim'
  use 'udalov/kotlin-vim'
  use 'hsanson/vim-android'
  use 'keith/swift.vim'



  --Estetica y UI
  ---- Alternativa moderna a Startify con íconos y layout configurable
use {
  'glepnir/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    require('dashboard').setup({})
  end,
  requires = {'nvim-tree/nvim-web-devicons'}
}

-- Cursor animado al moverse
use {
  'gen740/SmoothCursor.nvim',
  config = function()
    require('smoothcursor').setup()
  end
}

-- Mejores líneas de indentación (más visual que indentLine)
use {
  'lukas-reineke/indent-blankline.nvim',
  config = function()
    require("ibl").setup()
  end
}

-- Diagnóstico mejorado para errores, referencias y más
use {
  'folke/trouble.nvim',
  requires = 'nvim-tree/nvim-web-devicons',
  config = function()
    require("trouble").setup()
  end
}
-- Framework de testing para múltiples lenguajes
use {
  "nvim-neotest/neotest",
  requires = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim"
  }
}

-- Alternativa moderna a Floaterm con múltiples terminales
use {
  "akinsho/toggleterm.nvim",
  tag = '*',
  config = function()
    require("toggleterm").setup()
  end
}

-- Plugin moderno para comentar código
use {
  'numToStr/Comment.nvim',
  config = function()
    require('Comment').setup()
  end
}

-- Explorador de archivos más completo que nvim-tree
use {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  requires = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- optional
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup()
  end
}

  if packer_bootstrap then
    require('packer').sync()
  end
end)


