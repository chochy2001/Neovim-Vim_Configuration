-- Which-key: shows available keybindings as you type
return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300

            local wk = require("which-key")
            wk.setup({
                plugins = { spelling = { enabled = true } },
            })

            -- Register group labels so which-key shows clear categories
            wk.add({
                { "<leader>f", group = "Find/Search" },
                { "<leader>g", group = "Git" },
                { "<leader>gs", group = "Git Stage" },
                { "<leader>gc", group = "Git Conflict" },
                { "<leader>gd", group = "Git Diff" },
                { "<leader>gb", group = "Git Blame" },
                { "<leader>gh", group = "Git History" },
                { "<leader>fl", group = "Flutter" },
                { "<leader>x", group = "Diagnostics" },
                { "<leader>m", group = "Marks/Harpoon" },
                { "<leader>b", group = "Buffers" },
                { "<leader>w", group = "Windows" },
                { "<leader>t", group = "Terminal/Test" },
                { "<leader>r", group = "Run/Rename" },
                { "<leader>c", group = "Copilot AI" },
                { "<leader>d", group = "Debug" },
                { "<leader>z", group = "Fold/Zen" },
                { "<leader>q", group = "Session" },
                { "<leader>o", group = "Overseer/Oil" },
                { "<leader>s", group = "Split/Swap" },
                { "<leader>l", group = "LSP" },
                { "<leader>te", group = "Test" },
            })
        end,
    },
}
