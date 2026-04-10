-- lua/plugins/ui.lua
return {
    -- Enhanced notifications
    {
        "rcarriga/nvim-notify",
        event = "VeryLazy",
        config = function()
            -- Preserve existing vim.notify wrapper (from error-suppressor.lua)
            local original_notify = vim.notify
            local notify_plugin = require("notify")

            -- Simplified approach: preserve the filtering chain
            vim.notify = function(msg, level, opts)
                -- Save the current vim.notify (which will be this function)
                local current_notify = vim.notify

                -- Temporarily replace vim.notify with our fancy notify plugin
                -- This is what will get called if the message passes all filters
                vim.notify = notify_plugin

                -- Call the original wrapper chain
                -- If it returns early (suppressed), notify_plugin won't be called
                -- If it passes through, notify_plugin will be called instead of the original
                local result = original_notify(msg, level, opts)

                -- Restore our wrapper function
                vim.notify = current_notify

                return result
            end
        end,
    },
    -- Replaces vim.ui.input and vim.ui.select
    { "stevearc/dressing.nvim", event = "VeryLazy" },
    -- Icons (used by lualine, trouble, etc.)
    { "echasnovski/mini.icons", event = "VeryLazy" },
    -- Smooth cursor (visual effect)
    {
        "gen740/SmoothCursor.nvim",
        event = "VeryLazy",
        config = function()
            require("smoothcursor").setup()
        end,
    },
    -- Visual indentation lines
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = "VeryLazy",
        opts = {},
    },
    -- Auto-highlight word under cursor (like IDE variable highlighting)
    {
        "RRethy/vim-illuminate",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            delay = 200,
            large_file_cutoff = 2000,
            large_file_overrides = { providers = { "lsp" } },
        },
        config = function(_, opts)
            require("illuminate").configure(opts)
        end,
    },
}
