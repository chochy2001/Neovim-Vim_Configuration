-- lua/plugins/editing.lua
return {
    -- Easy motion
    { "easymotion/vim-easymotion", event = "VeryLazy" },
    -- Surround text easily (e.g. ysiw" to surround word with "")
    { "tpope/vim-surround",        event = "VeryLazy" },
    -- Auto-close parentheses, quotes, etc.
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter", -- Load only when entering insert mode
        config = function()
            require("nvim-autopairs").setup({})
            -- Integration with nvim-cmp if present
            local cmp_ok, cmp = pcall(require, "cmp")
            if cmp_ok then
                local cmp_autopairs_ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
                if cmp_autopairs_ok then
                    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
                end
            end
        end,
    },
    -- Comment code easily (gc, gcc, etc.)
    {
        "numToStr/Comment.nvim",
        event = "VeryLazy", -- Or use 'keys' if you have specific keymaps to trigger loading
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
