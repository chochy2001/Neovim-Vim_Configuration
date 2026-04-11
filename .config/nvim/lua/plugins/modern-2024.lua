-- Modern recommended plugins for 2024-2025
return {
    -- Code context (trending)
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "VeryLazy",
        opts = {
            enable = true,
            max_lines = 4,
            multiline_threshold = 20,
            mode = "cursor",
        },
    },

    -- Better find/replace experience (trending)
    {
        "MagicDuck/grug-far.nvim",
        cmd = "GrugFar",
        config = function()
            require('grug-far').setup({
                -- configuration here, or leave empty to use defaults
            })
        end,
        keys = {
            {
                "<leader>sr",
                function()
                    local grug = require('grug-far')
                    local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
                    grug.grug_far({
                        transient = true,
                        prefills = {
                            filesFilter = ext and ext ~= "" and "*." .. ext or nil,
                        }
                    })
                end,
                mode = { "n", "v" },
                desc = "Search and Replace"
            }
        }
    },

    -- dressing.nvim is configured in ui.lua
}