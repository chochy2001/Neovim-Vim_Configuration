-- Plugins modernos recomendados para 2024-2025
return {
    -- Context de código (trending)
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

    -- Mejor experiencia de find/replace (trending)
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

    -- Mejores ventanas de UI (ya tienes dressing.nvim pero confirmemos la config)
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

    -- Deshabilitado nvim-snippets: LuaSnip + friendly-snippets ya cubren snippets
    -- Deshabilitado Grapple: Harpoon ya cubre navegacion de bookmarks (harpoon.lua)
}