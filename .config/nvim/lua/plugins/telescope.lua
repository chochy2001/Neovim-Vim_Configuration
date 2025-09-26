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
            -- Categoria Find/Files unificada con prefijo <leader>f*
            vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find Grep" })
            vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Find Old Files" })
            vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
            vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find Help" })
            vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "Find Commands" })
            vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Find Keymaps" })

            -- Project/Symbol search - sincronizado con .ideavimrc
            vim.keymap.set("n", "<leader>ps", builtin.lsp_dynamic_workspace_symbols, { desc = "Find Project Symbols" })

            -- ELIMINADO: <leader><leader> conflicta con clear search highlight del .ideavimrc
            -- ELIMINADO: <leader>fd duplicado innecesario

            -- Mappings adicionales que funcionan bien
            vim.keymap.set("n", "<leader>.", builtin.find_files, { desc = "Quick Find Files" })
            vim.keymap.set("n", ",,", builtin.find_files, { desc = "Quick Find Files" })

            require("telescope").load_extension("ui-select")
        end,
    },
}
