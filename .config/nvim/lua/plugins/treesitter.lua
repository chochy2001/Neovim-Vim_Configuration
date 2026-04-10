-- Treesitter: syntax parsing, highlighting, and text objects
return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        -- New nvim-treesitter API (configs module was removed)
        main = "nvim-treesitter",
        opts = {
            ensure_installed = {
                "lua", "vim", "vimdoc", "query",
                "dart", "kotlin", "c", "cpp", "go",
                "python", "javascript", "typescript", "html", "css",
                "json", "yaml", "markdown", "bash",
            },
            auto_install = false,
        },
    },
    -- Text objects for functions, classes, arguments, etc.
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            -- Use vim.treesitter built-in for textobjects (new API)
            local ok, ts_repeat = pcall(require, "nvim-treesitter-textobjects.repeatable_move")

            -- Textobject selection keymaps
            local select_ok, ts_select = pcall(require, "nvim-treesitter-textobjects.select")
            if select_ok then
                local map = vim.keymap.set
                -- Around/inside function
                map({ "x", "o" }, "af", function() ts_select.select_textobject("@function.outer", "textobjects") end, { desc = "Around function" })
                map({ "x", "o" }, "if", function() ts_select.select_textobject("@function.inner", "textobjects") end, { desc = "Inside function" })
                -- Around/inside class
                map({ "x", "o" }, "ac", function() ts_select.select_textobject("@class.outer", "textobjects") end, { desc = "Around class" })
                map({ "x", "o" }, "ic", function() ts_select.select_textobject("@class.inner", "textobjects") end, { desc = "Inside class" })
                -- Around/inside argument
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
