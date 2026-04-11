-- Diagnostics list with Trouble v3
return {
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = "Trouble",
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
            { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
            { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List" },
            { "gR", "<cmd>Trouble lsp_references toggle<cr>", desc = "LSP References (Trouble)" },
            { "<leader>xn", function() vim.diagnostic.goto_next() end, desc = "Next Error/Diagnostic" },
            { "<leader>xp", function() vim.diagnostic.goto_prev() end, desc = "Previous Error/Diagnostic" },
        },
        opts = {},
    },
}
