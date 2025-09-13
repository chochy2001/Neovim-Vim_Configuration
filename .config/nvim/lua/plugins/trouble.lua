-- lua/plugins/trouble.lua
return {
    {
        "folke/trouble.nvim",
        -- Asegúrate que devicons esté disponible
        dependencies = { "nvim-tree/nvim-web-devicons" },
        -- Carga bajo demanda con comandos o teclas
        cmd = { "TroubleToggle", "Trouble" },
        keys = {
            { "<leader>xx", "<cmd>TroubleToggle<cr>",                       desc = "Toggle Trouble" },
            { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
            { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",  desc = "Document Diagnostics" },
            { "<leader>xl", "<cmd>TroubleToggle loclist<cr>",               desc = "Location List" },
            { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",              desc = "Quickfix List" },
            { "gR",         "<cmd>TroubleToggle lsp_references<cr>",        desc = "LSP References" },
        },
        config = function()
            require("trouble").setup({
                -- Tu configuración de Trouble aquí (ej. iconos, etc.)
                -- icons = false, -- ejemplo
            })
        end,
    },
}
