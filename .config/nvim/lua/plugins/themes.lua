-- lua/plugins/themes.lua
return {
    -- Temas que quieres tener disponibles para cambiar con :colorscheme
    {
        "dracula/vim",
        name = "dracula",
        lazy = false,
        priority = 1000,
        config = function()
            pcall(function()
                vim.cmd("colorscheme dracula")
            end)
        end,
    },
    -- Agregar config al theme que se quiere usar
    { "tomasr/molokai",                   name = "molokai",    lazy = true },
    { "altercation/vim-colors-solarized", name = "solarized",  lazy = true },
    { "joshdick/onedark.vim",             name = "onedark",    lazy = true },
    { "morhetz/gruvbox",                  name = "gruvbox",    lazy = true },
    { "rose-pine/neovim",                 name = "rose-pine",  lazy = true },
    { "catppuccin/nvim",                  name = "catppuccin", lazy = true },
}
