return {
    {
        "tpope/vim-fugitive",
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()

            vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", {})
            vim.keymap.set("n", "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>", {})
        end,
    },
    -- Dependencia para Neogit
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    },
    -- Interfaz de Git tipo Magit
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim", -- Opcional, para selectores
        },
        cmd = "Neogit",             -- Cargar al usar el comando
        config = function()
            require("neogit").setup({
                integrations = {
                    telescope = true, -- Activar si usas telescope
                    diffview = true, -- Activar integración con diffview
                },
                -- ... otras configuraciones de Neogit ...
            })
            vim.keymap.set("n", "<leader>gg", ":Neogit<CR>", { desc = "Open Neogit" })
        end,
    },
}
