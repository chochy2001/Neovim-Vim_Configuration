return {
    {
        "nvim-telescope/telescope-ui-select.nvim",
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        -- Carga cuando telescope cargue
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        config = function()
            -- Configuración específica de file_browser si es necesaria
            -- require("telescope").load_extension("file_browser")
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8", -- Actualizado a versión más reciente
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
            })
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
            vim.keymap.set("n", "<leader>pg", builtin.live_grep, {})
            vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, {})

            -- Double Shift to open file finder (like IntelliJ)
            -- Using a more reliable approach with double tap detection
            local function setup_double_shift()
                local shift_pressed_time = 0
                local double_shift_timeout = 300 -- milliseconds

                vim.keymap.set('n', '<S-Space>', function()
                    local current_time = vim.fn.reltime()
                    local time_diff = vim.fn.reltimefloat(vim.fn.reltime(shift_pressed_time, current_time)) * 1000

                    if time_diff < double_shift_timeout then
                        -- Double shift detected, open file finder
                        builtin.find_files()
                    else
                        -- Single shift, just update the time
                        shift_pressed_time = current_time
                    end
                end, { desc = "Double Shift to find files" })
            end

            -- Alternative simpler approach: use a custom sequence
            vim.keymap.set("n", "<leader><leader>f", builtin.find_files, { desc = "Quick find files (Double Leader + f)" })
            -- Even simpler: use double leader as it's already mapped but add 'f' for files
            vim.keymap.set("n", ",,", builtin.find_files, { desc = "Quick find files (Double comma)" })

            require("telescope").load_extension("ui-select")
        end,
    },
}
