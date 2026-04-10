-- Editing tools: motion, surround, comments, pairs, search
return {
    -- Flash: modern jump/motion (replaces easymotion, treesitter-aware)
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash: Jump" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash: Treesitter select" },
            { "r", mode = "o", function() require("flash").remote() end, desc = "Flash: Remote" },
            { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Flash: Treesitter search" },
        },
    },
    -- Surround text (ysiw", cs"', ds")
    { "tpope/vim-surround", event = "VeryLazy" },
    -- Auto-close parentheses, quotes, etc.
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({})
            local cmp_ok, cmp = pcall(require, "cmp")
            if cmp_ok then
                local cmp_autopairs_ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
                if cmp_autopairs_ok then
                    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
                end
            end
        end,
    },
    -- Comment code (gc, gcc)
    {
        "numToStr/Comment.nvim",
        event = "VeryLazy",
        config = function()
            require("Comment").setup()
        end,
    },
    -- Tag bar (requires ctags installed externally)
    {
        "preservim/tagbar",
        cmd = "TagbarToggle",
    },
    -- Highlight TODO/FIXME/HACK/NOTE in code
    {
        "folke/todo-comments.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
        keys = {
            { "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO comment" },
            { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous TODO comment" },
            { "<leader>xt", "<cmd>Trouble todo<cr>", desc = "TODOs in Trouble" },
        },
    },
}
