-- Treesitter: syntax parsing, highlighting, and text objects
return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "nvim-treesitter/playground",
            "hiphish/rainbow-delimiters.nvim",
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        config = function()
            local ts_configs = require("nvim-treesitter.configs")
            ts_configs.setup({
                ensure_installed = {
                    "lua", "vim", "vimdoc", "query",
                    "dart", "kotlin", "c", "cpp", "go",
                    "json", "yaml", "markdown", "bash",
                    -- swift requires tree-sitter CLI: npm install -g tree-sitter-cli
                    -- then run :TSInstall swift
                },
                sync_install = false,
                auto_install = false,
                highlight = { enable = true },
                indent = { enable = true },

                -- Text objects: select/move by function, class, parameter, etc.
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = { query = "@function.outer", desc = "Around function" },
                            ["if"] = { query = "@function.inner", desc = "Inside function" },
                            ["ac"] = { query = "@class.outer", desc = "Around class" },
                            ["ic"] = { query = "@class.inner", desc = "Inside class" },
                            ["aa"] = { query = "@parameter.outer", desc = "Around argument" },
                            ["ia"] = { query = "@parameter.inner", desc = "Inside argument" },
                            ["ai"] = { query = "@conditional.outer", desc = "Around conditional" },
                            ["ii"] = { query = "@conditional.inner", desc = "Inside conditional" },
                            ["al"] = { query = "@loop.outer", desc = "Around loop" },
                            ["il"] = { query = "@loop.inner", desc = "Inside loop" },
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]f"] = { query = "@function.outer", desc = "Next function start" },
                            ["]c"] = { query = "@class.outer", desc = "Next class start" },
                            ["]a"] = { query = "@parameter.inner", desc = "Next argument" },
                        },
                        goto_next_end = {
                            ["]F"] = { query = "@function.outer", desc = "Next function end" },
                            ["]C"] = { query = "@class.outer", desc = "Next class end" },
                        },
                        goto_previous_start = {
                            ["[f"] = { query = "@function.outer", desc = "Previous function start" },
                            ["[c"] = { query = "@class.outer", desc = "Previous class start" },
                            ["[a"] = { query = "@parameter.inner", desc = "Previous argument" },
                        },
                        goto_previous_end = {
                            ["[F"] = { query = "@function.outer", desc = "Previous function end" },
                            ["[C"] = { query = "@class.outer", desc = "Previous class end" },
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<leader>sa"] = { query = "@parameter.inner", desc = "Swap with next argument" },
                        },
                        swap_previous = {
                            ["<leader>sA"] = { query = "@parameter.inner", desc = "Swap with previous argument" },
                        },
                    },
                },
            })

            -- rainbow-delimiters: only attach to buffers with a valid parser
            local ok, rd = pcall(require, "rainbow-delimiters")
            if ok then
                vim.g.rainbow_delimiters = {
                    strategy = {
                        [""] = function()
                            local bufnr = vim.api.nvim_get_current_buf()
                            local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
                            if not lang then return nil end
                            local ok_parser = pcall(vim.treesitter.get_parser, bufnr, lang)
                            if not ok_parser then return nil end
                            return rd.strategy["global"]
                        end,
                    },
                }
            end
        end,
    },
}
