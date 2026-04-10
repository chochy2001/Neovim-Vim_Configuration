-- lua/plugins/lualine.lua
return {
    {
        "nvim-lualine/lualine.nvim",
        -- Make sure devicons is loaded, lazy.nvim usually handles this well
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VeryLazy", -- Load when the UI is ready
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto", -- Uses the colorscheme theme or choose a specific one
                    section_separators = { left = "", right = "" },
                    component_separators = { left = "", right = "" },
                    icons_enabled = true,
                    -- ... other global options if needed ...
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff" },
                    lualine_c = { { "filename", path = 1 }, { "diagnostics", sources = { "nvim_lsp" } } },
                    lualine_x = { "filetype", "encoding", "fileformat" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
                -- ... other sections or configurations ...
            })
        end,
    },
}
