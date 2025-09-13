-- lua/plugins/lualine.lua
return {
    {
        "nvim-lualine/lualine.nvim",
        -- Asegúrate que devicons se cargue, lazy.nvim suele manejarlo bien
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VeryLazy", -- Cargarla cuando la UI esté lista
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto", -- Usa el tema de colorscheme o elige uno específico
                    section_separators = { left = "", right = "" },
                    component_separators = { left = "", right = "" },
                    icons_enabled = true,
                    -- ... otras opciones globales si las necesitas ...
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff" },
                    lualine_c = { { "filename", path = 1 }, { "diagnostics", sources = { "nvim_lsp" } } },
                    lualine_x = { "filetype", "encoding", "fileformat" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
                -- ... otras secciones o configuraciones ...
            })
        end,
    },
}
