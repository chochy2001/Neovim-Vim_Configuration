-- lua/plugins/ui.lua
return {
    -- Enhanced notifications
    {
        "rcarriga/nvim-notify",
        event = "VeryLazy",
        opts = {
            timeout = 2500,
            stages = "fade",
            render = "compact",
            top_down = false,
            max_height = function() return math.floor(vim.o.lines * 0.4) end,
            max_width = function() return math.floor(vim.o.columns * 0.45) end,
        },
        config = function(_, opts)
            local notify = require("notify")
            notify.setup(opts)
            vim.notify = notify
        end,
    },
    -- vim.ui.input only. vim.ui.select is owned by telescope-ui-select
    -- (loading both made the picker flip depending on which loaded last).
    { "stevearc/dressing.nvim", event = "VeryLazy", opts = { select = { enabled = false } } },
    -- Icons: nvim-web-devicons is the single provider (see icons-fix.lua).
    -- mini.icons was removed: nothing required it, avoids duplicate providers.
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
        opts = {
            indent = { char = "│", tab_char = "│" },
            scope = { enabled = true, show_start = false, show_end = false },
            exclude = { filetypes = { "dashboard", "lazy", "mason", "neo-tree", "Trouble" } },
        },
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
    -- Hex / Tailwind colors in CSS, HTML, Astro, Flutter
    {
        "brenoprata10/nvim-highlight-colors",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            render = "background",
            enable_tailwind = true,
        },
    },
    -- Winbar breadcrumbs (file > symbol) — does not replace lualine
    {
        "Bekaboo/dropbar.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {},
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
                -- fidget.nvim already shows LSP progress; skip noice's copy
                progress = { enabled = false },
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
