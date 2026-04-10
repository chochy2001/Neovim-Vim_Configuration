-- Smart folding with treesitter and LSP support
return {
    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        event = "BufReadPost",
        opts = {
            provider_selector = function(_, filetype, _)
                -- Use treesitter for most languages, indent as fallback
                local ftMap = {
                    vim = "indent",
                    git = "",
                }
                return ftMap[filetype] or { "treesitter", "indent" }
            end,
        },
        config = function(_, opts)
            require("ufo").setup(opts)
            -- Use ufo's fold commands for zR/zM
            vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds (ufo)" })
            vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds (ufo)" })
            vim.keymap.set("n", "zK", function()
                local winid = require("ufo").peekFoldedLinesUnderCursor()
                if not winid then
                    vim.lsp.buf.hover()
                end
            end, { desc = "Peek fold or hover" })
        end,
    },
}
