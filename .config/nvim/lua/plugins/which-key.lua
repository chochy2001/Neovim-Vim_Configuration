return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy", -- Loads the plugin early, after VimEnter
        config = function()
            -- Vim options related to keymap timeout
            vim.o.timeout = true
            vim.o.timeoutlen = 300 -- Time in milliseconds to wait for the next key

            -- which-key configuration
            require("which-key").setup({
                -- You can add your custom which-key configuration here inside {}
                -- or leave it empty {} to use the default configuration.
                -- Example:
                -- plugins = { spelling = true },
                -- window = { border = "single" },
            })
        end,
    },
}
