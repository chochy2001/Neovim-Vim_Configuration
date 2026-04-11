-- lua/plugins/ui.lua
return {
    -- Enhanced notifications
    {
        "rcarriga/nvim-notify",
        event = "VeryLazy",
        opts = {
            timeout = 3000,
            max_height = function() return math.floor(vim.o.lines * 0.75) end,
            max_width = function() return math.floor(vim.o.columns * 0.75) end,
        },
        config = function(_, opts)
            local notify = require("notify")
            notify.setup(opts)
            vim.notify = notify
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
    -- Noice: modern command line, messages, and popups UI
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                lsp_doc_border = true,
            },
            routes = {
                -- Hide "written" messages
                { filter = { event = "msg_show", kind = "", find = "written" }, opts = { skip = true } },
            },
        },
    },
}
