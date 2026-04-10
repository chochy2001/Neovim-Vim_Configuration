-- Modern recommended plugins for 2024-2025
return {
    -- Code context (trending)
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "VeryLazy",
        config = function()
            require("treesitter-context").setup({
                enable = true,
                max_lines = 4,
                patterns = {
                    default = {
                        'class',
                        'function',
                        'method',
                        'for',
                        'while',
                        'if',
                        'switch',
                        'case',
                    },
                },
            })
        end,
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

    -- Better UI windows (you already have dressing.nvim but let's confirm the config)
    {
        "stevearc/dressing.nvim",
        lazy = true,
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
    },

    -- Disabled nvim-snippets: LuaSnip + friendly-snippets already cover snippets
    -- Disabled Grapple: Harpoon already covers bookmark navigation (harpoon.lua)
}