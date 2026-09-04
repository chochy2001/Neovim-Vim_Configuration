return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VeryLazy",
        config = function()
            local function lsp_names()
                local buf = vim.api.nvim_get_current_buf()
                local names = {}
                for _, c in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
                    if c.name ~= "null-ls" then
                        table.insert(names, c.name)
                    end
                end
                if #names == 0 then
                    return ""
                end
                return " " .. table.concat(names, " ")
            end

            require("lualine").setup({
                options = {
                    theme = "auto",
                    globalstatus = true,
                    section_separators = { left = "", right = "" },
                    component_separators = { left = "", right = "" },
                    icons_enabled = true,
                    disabled_filetypes = { statusline = { "dashboard", "alpha" } },
                },
                sections = {
                    lualine_a = { { "mode", icon = "" } },
                    lualine_b = { { "branch", icon = "" }, "diff" },
                    lualine_c = {
                        { "filename", path = 1, symbols = { modified = " ●", readonly = " " } },
                        { "diagnostics", sources = { "nvim_lsp" }, symbols = { error = " ", warn = " ", info = " ", hint = " " } },
                    },
                    lualine_x = { lsp_names, "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
                inactive_sections = {
                    lualine_c = { { "filename", path = 1 } },
                    lualine_x = { "location" },
                },
            })
        end,
    },
}
