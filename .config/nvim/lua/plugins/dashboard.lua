return {
    {
        "glepnir/dashboard-nvim",
        event = "VimEnter",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local dashboard = require("dashboard")
            dashboard.setup({
                theme = "doom",
                config = {
                    header = {
                        "",
                        "",
                        " .d8888b.        d8888 8888888b.  8888888b.  8888888888  .d8888b.  8888888  .d8888b.",
                        "d88P  Y88b      d88888 888   Y88b 888   Y88b 888        d88P  Y88b   888   d88P  Y88b",
                        "888    888     d88P888 888    888 888    888 888        Y88b.        888   Y88b.",
                        "888           d88P 888 888   d88P 888    888 8888888     Y888b.      888    Y888b.",
                        "888          d88P  888 8888888P   888    888 888            Y88b.    888       Y88b.",
                        "888    888  d88P   888 888        888    888 888              888    888         888",
                        "Y88b  d88P d8888888888 888        888   d88P 888        Y88b  d88P   888   Y88b  d88P",
                        " Y8888P   d88P     888 888        8888888P   8888888888  Y8888P   8888888   Y8888P",
                        "",
                        "                          Neovim " .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch,
                        "",
                        "",
                    },
                    center = {
                        { icon = "  ", icon_hl = "Title", desc = "[1]  Find File            ", desc_hl = "String",  key = "1", key_hl = "Number", action = "Telescope find_files" },
                        { icon = "  ", icon_hl = "Title", desc = "[2]  Find Word            ", desc_hl = "String",  key = "2", key_hl = "Number", action = "Telescope live_grep" },
                        { icon = "  ", icon_hl = "Title", desc = "[3]  Recent Files         ", desc_hl = "String",  key = "3", key_hl = "Number", action = "Telescope oldfiles" },
                        { icon = "  ", icon_hl = "Title", desc = "[4]  File Explorer        ", desc_hl = "String",  key = "4", key_hl = "Number", action = "Neotree toggle" },
                        { icon = "  ", icon_hl = "Title", desc = "[5]  Terminal             ", desc_hl = "String",  key = "5", key_hl = "Number", action = "ToggleTerm" },
                        { icon = "  ", icon_hl = "Title", desc = "[6]  Edit Config          ", desc_hl = "String",  key = "6", key_hl = "Number", action = "edit " .. vim.fn.stdpath("config") .. "/init.lua" },
                        { icon = "  ", icon_hl = "Title", desc = "[7]  Plugin Sync (Lazy)   ", desc_hl = "String",  key = "7", key_hl = "Number", action = "Lazy sync" },
                        { icon = "  ", icon_hl = "Title", desc = "[8]  LSP Manager (Mason)  ", desc_hl = "String",  key = "8", key_hl = "Number", action = "Mason" },
                        { icon = "  ", icon_hl = "Title", desc = "[9]  Copilot Chat         ", desc_hl = "String",  key = "9", key_hl = "Number", action = "CopilotChatToggle" },
                        { icon = "  ", icon_hl = "Error", desc = "[q]  Quit                 ", desc_hl = "Comment", key = "q", key_hl = "Error",  action = "qa" },
                    },
                    footer = function()
                        local stats = require("lazy").stats()
                        return {
                            "",
                            stats.loaded .. "/" .. stats.count .. " plugins loaded in " .. string.format("%.1f", stats.startuptime) .. " ms",
                        }
                    end,
                },
            })
        end,
    },
}
