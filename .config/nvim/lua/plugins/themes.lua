-- lua/plugins/themes.lua

-- Configuración del tema por defecto (cambia aquí para usar otro tema)
local DEFAULT_THEME = "dracula"  -- Opciones: "dracula", "gruvbox", "catppuccin", "onedark", etc.

return {
    -- Tema por defecto (se carga inmediatamente)
    {
        "dracula/vim",
        name = "dracula",
        lazy = DEFAULT_THEME ~= "dracula",
        priority = DEFAULT_THEME == "dracula" and 1000 or nil,
        config = function()
            if DEFAULT_THEME == "dracula" then
                pcall(function()
                    vim.cmd("colorscheme dracula")
                end)
            end
        end,
    },

    -- Otros temas disponibles (carga perezosa)
    {
        "tomasr/molokai",
        name = "molokai",
        lazy = DEFAULT_THEME ~= "molokai",
        priority = DEFAULT_THEME == "molokai" and 1000 or nil,
        config = function()
            if DEFAULT_THEME == "molokai" then
                pcall(function()
                    vim.cmd("colorscheme molokai")
                end)
            end
        end,
    },
    {
        "altercation/vim-colors-solarized",
        name = "solarized",
        lazy = DEFAULT_THEME ~= "solarized",
        priority = DEFAULT_THEME == "solarized" and 1000 or nil,
        config = function()
            if DEFAULT_THEME == "solarized" then
                pcall(function()
                    vim.cmd("colorscheme solarized")
                end)
            end
        end,
    },
    {
        "joshdick/onedark.vim",
        name = "onedark",
        lazy = DEFAULT_THEME ~= "onedark",
        priority = DEFAULT_THEME == "onedark" and 1000 or nil,
        config = function()
            if DEFAULT_THEME == "onedark" then
                pcall(function()
                    vim.cmd("colorscheme onedark")
                end)
            end
        end,
    },
    {
        "morhetz/gruvbox",
        name = "gruvbox",
        lazy = DEFAULT_THEME ~= "gruvbox",
        priority = DEFAULT_THEME == "gruvbox" and 1000 or nil,
        config = function()
            if DEFAULT_THEME == "gruvbox" then
                pcall(function()
                    vim.cmd("colorscheme gruvbox")
                end)
            end
        end,
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = DEFAULT_THEME ~= "rose-pine",
        priority = DEFAULT_THEME == "rose-pine" and 1000 or nil,
        config = function()
            if DEFAULT_THEME == "rose-pine" then
                pcall(function()
                    vim.cmd("colorscheme rose-pine")
                end)
            end
        end,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = DEFAULT_THEME ~= "catppuccin",
        priority = DEFAULT_THEME == "catppuccin" and 1000 or nil,
        config = function()
            if DEFAULT_THEME == "catppuccin" then
                pcall(function()
                    vim.cmd("colorscheme catppuccin")
                end)
            end
        end,
    },
}
