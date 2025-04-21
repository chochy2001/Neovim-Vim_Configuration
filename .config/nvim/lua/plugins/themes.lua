-- lua/plugins/themes.lua
return {
  -- Temas que quieres tener disponibles para cambiar con :colorscheme
  { "dracula/vim",        name = "dracula",   lazy = true },
  { "tomasr/molokai",     name = "molokai",   lazy = true },
  { "altercation/vim-colors-solarized", name = "solarized", lazy = true },
  { "joshdick/onedark.vim", name = "onedark",   lazy = true },
  { "morhetz/gruvbox",    name = "gruvbox",   lazy = true },
  { "rose-pine/neovim",   name = "rose-pine", lazy = false, priority = 1000 }, -- Ejemplo si quieres rose-pine por defecto
   -- Catppuccin ya está en su propio archivo y se carga primero
}
