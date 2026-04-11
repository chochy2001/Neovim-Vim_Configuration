-- Treesitter: parser management, syntax highlighting, and text objects
return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = function()
            pcall(function() require("nvim-treesitter").update() end)
        end,
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        config = function()
            local langs = {
                "lua", "vim", "vimdoc", "query",
                "dart", "kotlin", "c", "cpp", "go",
                "python", "javascript", "typescript", "html", "css",
                "json", "yaml", "markdown", "markdown_inline", "bash",
            }

            -- Install missing parsers
            local ts = require("nvim-treesitter")
            local installed = ts.get_installed()
            local installed_set = {}
            for _, l in ipairs(installed) do installed_set[l] = true end
            local to_install = {}
            for _, l in ipairs(langs) do
                if not installed_set[l] then
                    table.insert(to_install, l)
                end
            end
            if #to_install > 0 then
                ts.install(to_install)
            end

            -- Enable treesitter highlighting via FileType autocmd (required in new nvim-treesitter)
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true }),
                callback = function()
                    local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
                    if lang and pcall(vim.treesitter.query.get, lang, "highlights") then
                        pcall(vim.treesitter.start)
                    end
                end,
            })
        end,
    },
    -- Text objects for functions, classes, arguments, etc.
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            -- Textobject selection keymaps
            local select_ok, ts_select = pcall(require, "nvim-treesitter-textobjects.select")
            if select_ok then
                local map = vim.keymap.set
                map({ "x", "o" }, "af", function() ts_select.select_textobject("@function.outer", "textobjects") end, { desc = "Around function" })
                map({ "x", "o" }, "if", function() ts_select.select_textobject("@function.inner", "textobjects") end, { desc = "Inside function" })
                map({ "x", "o" }, "ac", function() ts_select.select_textobject("@class.outer", "textobjects") end, { desc = "Around class" })
                map({ "x", "o" }, "ic", function() ts_select.select_textobject("@class.inner", "textobjects") end, { desc = "Inside class" })
                map({ "x", "o" }, "aa", function() ts_select.select_textobject("@parameter.outer", "textobjects") end, { desc = "Around argument" })
                map({ "x", "o" }, "ia", function() ts_select.select_textobject("@parameter.inner", "textobjects") end, { desc = "Inside argument" })
            end

            -- Move keymaps
            local move_ok, ts_move = pcall(require, "nvim-treesitter-textobjects.move")
            if move_ok then
                local map = vim.keymap.set
                map({ "n", "x", "o" }, "]f", function() ts_move.goto_next_start("@function.outer", "textobjects") end, { desc = "Next function" })
                map({ "n", "x", "o" }, "[f", function() ts_move.goto_previous_start("@function.outer", "textobjects") end, { desc = "Previous function" })
                map({ "n", "x", "o" }, "]c", function() ts_move.goto_next_start("@class.outer", "textobjects") end, { desc = "Next class" })
                map({ "n", "x", "o" }, "[c", function() ts_move.goto_previous_start("@class.outer", "textobjects") end, { desc = "Previous class" })
            end

            -- Swap keymaps
            local swap_ok, ts_swap = pcall(require, "nvim-treesitter-textobjects.swap")
            if swap_ok then
                vim.keymap.set("n", "<leader>sa", function() ts_swap.swap_next("@parameter.inner", "textobjects") end, { desc = "Swap with next argument" })
                vim.keymap.set("n", "<leader>sA", function() ts_swap.swap_previous("@parameter.inner", "textobjects") end, { desc = "Swap with previous argument" })
            end
        end,
    },
}
