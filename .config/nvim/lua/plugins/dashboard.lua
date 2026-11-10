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
            local nerd = require("icons").nerd_font
            -- Icons as code points (see icons.lua): pasted glyphs get stripped.
            local function item(code, desc, key, action)
                return {
                    icon = nerd and (vim.fn.nr2char(code) .. "  ") or "",
                    icon_hl = "DashboardIcon",
                    desc = desc,
                    desc_hl = "DashboardDesc",
                    key = key,
                    key_hl = "DashboardKey",
                    key_format = " [%s]",
                    action = action,
                }
            end
            -- CAPDESIS gold header, readable on dark and light backgrounds.
            -- Reapplied after :colorscheme, which clears custom groups.
            local function colors()
                vim.api.nvim_set_hl(0, "DashboardHeader", { fg = "#F3A63D", bold = true })
                vim.api.nvim_set_hl(0, "DashboardKey", { link = "Special" })
                vim.api.nvim_set_hl(0, "DashboardIcon", { link = "Function" })
                vim.api.nvim_set_hl(0, "DashboardFooter", { link = "Comment" })
            end
            colors()
            vim.api.nvim_create_autocmd("ColorScheme", {
                group = vim.api.nvim_create_augroup("dashboard_colors", { clear = true }),
                callback = colors,
            })
            require("dashboard").setup({
                theme = "doom",
                config = {
                    header = {
                        "",
                        "   ██████  █████  ██████  ██████  ███████ ███████ ██ ███████ ",
                        "  ██      ██   ██ ██   ██ ██   ██ ██      ██      ██ ██      ",
                        "  ██      ███████ ██████  ██   ██ █████   ███████ ██ ███████ ",
                        "  ██      ██   ██ ██      ██   ██ ██           ██ ██      ██ ",
                        "   ██████ ██   ██ ██      ██████  ███████ ███████ ██ ███████ ",
                        "",
                        string.format("Neovim %d.%d.%d  ·  CAPDESIS", v.major, v.minor, v.patch),
                        "",
                    },
                    center = {
                        item(0xF002, "Find file", "f", "Telescope find_files"),
                        item(0xF0B0, "Live grep", "g", "Telescope live_grep"),
                        item(0xF1DA, "Recent files", "r", "Telescope oldfiles"),
                        item(0xF07B, "Explorer", "e", "Neotree toggle"),
                        item(0xEB99, "AI (opencode)", "a", function()
                            pcall(require, "toggleterm")
                            require("ai-terminals").toggle("opencode")
                        end),
                        item(0xF0AD, "Mason / LSP", "m", "Mason"),
                        item(0xF1E6, "Lazy plugins", "l", "Lazy"),
                        item(0xF011, "Quit", "q", "qa"),
                    },
                    footer = function()
                        local stats = require("lazy").stats()
                        local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
                        local timing = (stats.startuptime or 0) > 0
                                and string.format(
                                    "%d/%d plugins in %.0f ms",
                                    stats.loaded,
                                    stats.count,
                                    stats.startuptime
                                )
                            or string.format("%d plugins (lazy)", stats.count)
                        return {
                            "",
                            cwd,
                            timing,
                            "",
                            "<Space> waits for the key menu  ·  :Tutor to practise",
                        }
                    end,
                },
            })
        end,
    },
}
