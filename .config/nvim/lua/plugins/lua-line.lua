return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VeryLazy",
        config = function()
            local icons = require("icons")
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
                return icons.lsp .. " " .. table.concat(names, " ")
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
                    lualine_a = { "mode" },
                    lualine_b = { { "branch", icon = icons.git_branch }, "diff" },
                    lualine_c = {
                        {
                            "filename",
                            path = 1,
                            symbols = { modified = " ●", readonly = " " .. icons.readonly },
                        },
                        {
                            "diagnostics",
                            sources = { "nvim_lsp" },
                            symbols = {
                                error = icons.diagnostics.error .. " ",
                                warn = icons.diagnostics.warn .. " ",
                                info = icons.diagnostics.info .. " ",
                                hint = icons.diagnostics.hint .. " ",
                            },
                        },
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
