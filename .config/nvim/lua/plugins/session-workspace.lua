-- Gestión de sesiones y workspaces para múltiples proyectos
return {
    -- Session management moderno
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = {
            dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
            options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" }
        },
        keys = {
            { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
            { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
            { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
        }
    },

    -- Project management avanzado
    {
        "ahmedkhalf/project.nvim",
        event = "VeryLazy",
        config = function()
            require("project_nvim").setup({
                manual_mode = false,
                detection_methods = { "lsp", "pattern" },
                patterns = {
                    ".git", "_darcs", ".hg", ".bzr", ".svn",
                    "Makefile", "package.json", "pubspec.yaml",
                    "Cargo.toml", "go.mod", "CMakeLists.txt",
                    "build.gradle", "build.gradle.kts", "pom.xml",
                    "Package.swift", "*.xcodeproj", "*.xcworkspace"
                },
                ignore_lsp = {},
                exclude_dirs = {},
                show_hidden = false,
                silent_chdir = true,
                scope_chdir = 'global',
                datapath = vim.fn.stdpath("data"),
            })

            -- Integration with telescope
            require('telescope').load_extension('projects')

            -- Keymaps
            vim.keymap.set("n", "<leader>fp", "<Cmd>Telescope projects<CR>", { desc = "Find Projects" })
        end
    },

    -- Workspace tabs mejoradas
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        event = "VeryLazy",
        config = function()
            require("bufferline").setup({
                options = {
                    mode = "buffers", -- "tabs" or "buffers"
                    themable = true,
                    numbers = "none", -- "none" | "ordinal" | "buffer_id" | "both"
                    close_command = "bdelete! %d",
                    right_mouse_command = "bdelete! %d",
                    left_mouse_command = "buffer %d",
                    middle_mouse_command = nil,
                    indicator = {
                        icon = '▎',
                        style = 'icon',
                    },
                    buffer_close_icon = '',
                    modified_icon = '●',
                    close_icon = '',
                    left_trunc_marker = '',
                    right_trunc_marker = '',
                    max_name_length = 18,
                    max_prefix_length = 15,
                    truncate_names = true,
                    tab_size = 21,
                    diagnostics = "nvim_lsp",
                    diagnostics_update_in_insert = false,
                    diagnostics_indicator = function(count, level, diagnostics_dict, context)
                        local icon = level:match("error") and " " or " "
                        return " " .. icon .. count
                    end,
                    show_buffer_icons = true,
                    show_buffer_close_icons = true,
                    show_close_icon = true,
                    show_tab_indicators = true,
                    show_duplicate_prefix = true,
                    persist_buffer_sort = true,
                    separator_style = "slant", -- "slant" | "thick" | "thin" | { 'any', 'any' }
                    enforce_regular_tabs = false,
                    always_show_bufferline = true,
                    hover = {
                        enabled = true,
                        delay = 200,
                        reveal = {'close'}
                    },
                    sort_by = 'insert_after_current',
                    offsets = {
                        {
                            filetype = "neo-tree",
                            text = "File Explorer",
                            text_align = "left",
                            separator = true
                        }
                    },
                    custom_filter = function(buf_number, buf_numbers)
                        -- filter out filetypes you don't want to see
                        if vim.bo[buf_number].filetype ~= "oil" then
                            return true
                        end
                        -- filter out by buffer name
                        if vim.fn.bufname(buf_number) ~= "" then
                            return true
                        end
                        -- filter out based on arbitrary rules
                        -- e.g. filter out vim help files
                        if vim.bo[buf_number].filetype == "help" then
                            return false
                        end
                        return true
                    end,
                }
            })

            -- Keymaps para bufferline
            vim.keymap.set("n", "<S-l>", ":BufferLineCycleNext<CR>", { desc = "Next Buffer" })
            vim.keymap.set("n", "<S-h>", ":BufferLineCyclePrev<CR>", { desc = "Previous Buffer" })
            vim.keymap.set("n", "<leader>bd", ":BufferLinePickClose<CR>", { desc = "Pick Buffer to Close" })
            vim.keymap.set("n", "<leader>bl", ":BufferLineCloseRight<CR>", { desc = "Close Buffers to Right" })
            vim.keymap.set("n", "<leader>bh", ":BufferLineCloseLeft<CR>", { desc = "Close Buffers to Left" })
            vim.keymap.set("n", "<leader>bp", ":BufferLinePick<CR>", { desc = "Pick Buffer" })
            vim.keymap.set("n", "<leader>bt", ":BufferLineTogglePin<CR>", { desc = "Toggle Pin Buffer" })
        end
    },

    -- Working directory management (comentado temporalmente)
    -- {
    --     "airblade/vim-rooter",
    --     event = "VeryLazy",
    --     config = function()
    --         vim.g.rooter_patterns = {
    --             '.git', '.hg', '.svn', '.bzr', '_darcs',
    --             'package.json', 'pubspec.yaml', 'Cargo.toml', 'go.mod',
    --             'CMakeLists.txt', 'Makefile', 'build.gradle', 'build.gradle.kts',
    --             'pom.xml', 'Package.swift', '*.xcodeproj', '*.xcworkspace'
    --         }
    --         vim.g.rooter_silent_chdir = 1
    --         vim.g.rooter_resolve_links = 1
    --     end
    -- },

    -- Better window management
    {
        "sindrets/winshift.nvim",
        cmd = "WinShift",
        config = function()
            require("winshift").setup({
                highlight_moving_win = true,
                focused_hl_group = "Visual",
                moving_win_options = {
                    wrap = false,
                    cursorline = false,
                    cursorcolumn = false,
                    colorcolumn = "",
                },
                keymaps = {
                    disable_defaults = false,
                    win_move_mode = {
                        ["h"] = "left",
                        ["j"] = "down",
                        ["k"] = "up",
                        ["l"] = "right",
                        ["H"] = "far_left",
                        ["J"] = "far_down",
                        ["K"] = "far_up",
                        ["L"] = "far_right",
                        ["<left>"] = "left",
                        ["<down>"] = "down",
                        ["<up>"] = "up",
                        ["<right>"] = "right",
                        ["<S-left>"] = "far_left",
                        ["<S-down>"] = "far_down",
                        ["<S-up>"] = "far_up",
                        ["<S-right>"] = "far_right",
                    },
                },
            })

            vim.keymap.set("n", "<leader>wm", "<cmd>WinShift<cr>", { desc = "WinShift: Move Window" })
            vim.keymap.set("n", "<leader>ws", "<cmd>WinShift swap<cr>", { desc = "WinShift: Swap Window" })
        end
    },

    -- Focus mode para concentración
    {
        "folke/zen-mode.nvim",
        cmd = "ZenMode",
        opts = {
            window = {
                backdrop = 0.95,
                width = 120,
                height = 1,
                options = {
                    signcolumn = "no",
                    number = false,
                    relativenumber = false,
                    cursorline = false,
                    cursorcolumn = false,
                    foldcolumn = "0",
                    list = false,
                },
            },
            plugins = {
                options = {
                    enabled = true,
                    ruler = false,
                    showcmd = false,
                    laststatus = 0,
                },
                twilight = { enabled = true },
                gitsigns = { enabled = false },
                tmux = { enabled = false },
                kitty = {
                    enabled = false,
                    font = "+4",
                },
                alacritty = {
                    enabled = false,
                    font = "14",
                },
                wezterm = {
                    enabled = false,
                    font = "+4",
                },
            },
        },
        keys = {
            { "<leader>zz", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
        },
    },

    -- Twilight para highlighting de código actual
    {
        "folke/twilight.nvim",
        opts = {
            dimming = {
                alpha = 0.25,
                color = { "Normal", "#ffffff" },
                term_bg = "#000000",
                inactive = false,
            },
            context = 10,
            treesitter = true,
            expand = {
                "function",
                "method",
                "table",
                "if_statement",
            },
            exclude = {},
        },
    },
}