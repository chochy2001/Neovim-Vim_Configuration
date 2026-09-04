return {
    {
        "glepnir/dashboard-nvim",
        event = "VimEnter",
        -- Only on a bare `nvim` (don't steal the buffer when opening a file)
        cond = function()
            return vim.fn.argc() == 0
        end,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local v = vim.version()
            require("dashboard").setup({
                theme = "doom",
                config = {
                    header = {
                        "",
                        "   ██████╗ █████╗ ██████╗ ██████╗ ███████╗███████╗██╗███████╗",
                        "  ██╔════╝██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔════╝██║██╔════╝",
                        "  ██║     ███████║██████╔╝██║  ██║█████╗  ███████╗██║███████╗",
                        "  ██║     ██╔══██║██╔═══╝ ██║  ██║██╔══╝  ╚════██║██║╚════██║",
                        "  ╚██████╗██║  ██║██║     ██████╔╝███████╗███████║██║███████║",
                        "   ╚═════╝╚═╝  ╚═╝╚═╝     ╚═════╝ ╚══════╝╚══════╝╚═╝╚══════╝",
                        "",
                        "              Neovim " .. v.major .. "." .. v.minor .. "." .. v.patch .. "  ·  CAPDESIS",
                        "",
                    },
                    center = {
                        { desc = "Find file", key = "f", key_hl = "Number", action = "Telescope find_files" },
                        { desc = "Live grep", key = "g", action = "Telescope live_grep" },
                        { desc = "Recent files", key = "r", action = "Telescope oldfiles" },
                        { desc = "Explorer", key = "e", action = "Neotree toggle" },
                        { desc = "AI (opencode)", key = "a", action = "lua require('ai-terminals').toggle('opencode')" },
                        { desc = "Mason / LSP", key = "m", action = "Mason" },
                        { desc = "Lazy plugins", key = "l", action = "Lazy" },
                        { desc = "Quit", key = "q", action = "qa" },
                    },
                    footer = function()
                        local stats = require("lazy").stats()
                        return {
                            "",
                            string.format("  %d/%d plugins loaded in %.0f ms", stats.loaded, stats.count, stats.startuptime),
                        }
                    end,
                },
            })
        end,
    },
}
