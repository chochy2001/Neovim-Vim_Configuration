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

    -- Para mejor manejo de snippets (alternativa moderna)
    {
        "garymjr/nvim-snippets",
        event = "InsertEnter",
        dependencies = { "rafamadriz/friendly-snippets" },
        opts = {
            friendly_snippets = true,
        },
    },

    -- Plugin para mejor navegación de código
    {
        "cbochs/grapple.nvim",
        opts = {
            scope = "git_branch",
        },
        event = { "BufReadPost", "BufNewFile" },
        cmd = "Grapple",
        keys = {
            { "<leader>m", "<cmd>Grapple toggle<cr>", desc = "Grapple toggle tag" },
            { "<leader>M", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple open tags window" },
            { "<leader>n", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple cycle next tag" },
            { "<leader>p", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple cycle previous tag" },
        },
    },
}