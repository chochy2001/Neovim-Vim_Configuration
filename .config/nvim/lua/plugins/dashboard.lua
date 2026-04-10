return {
    {
        "glepnir/dashboard-nvim",
        event = "VimEnter",                         -- Load dashboard when Neovim starts
        dependencies = { "nvim-tree/nvim-web-devicons" }, -- Needs devicons for icons
        config = function()
            local dashboard = require("dashboard")
            dashboard.setup({
                -- Theme and content configuration
                theme = "doom",
                config = {
                    header = {
                        [[  ______                             __                      __           ]],
                        [[ /      \                           |  \                    |  \          ]],
                        [[|  $$$$$$\  ______    ______    ____| $$  ______    _______  \$$  _______ ]],
                        [[| $$   \$$ |      \  /      \  /      $$ /      \  /       \|  \ /       \]],
                        [[| $$        \$$$$$$\|  $$$$$$\|  $$$$$$$|  $$$$$$\|  $$$$$$$| $$|  $$$$$$$]],
                        [[| $$   __  /      $$| $$  | $$| $$  | $$| $$    $$ \$$    \ | $$ \$$    \ ]],
                        [[| $$__/  \|  $$$$$$$| $$__/ $$| $$__| $$| $$$$$$$$ _\$$$$$$\| $$ _\$$$$$$\ ]],
                        [[ \$$    $$ \$$    $$| $$    $$ \$$    $$ \$$     \|       $$| $$|       $$]],
                        [[  \$$$$$$   \$$$$$$$| $$$$$$$   \$$$$$$$  \$$$$$$$ \$$$$$$$  \$$ \$$$$$$$ ]],
                        [[                    | $$                                                  ]],
                        [[                    | $$                                                  ]],
                        [[                     \$$                                                  ]],
                    },
                    center = {
                        -- Adjust the action for 'Plugin Sync' if using lazy.nvim
                        { icon = "1️⃣ ", desc = " Find File             ", action = "Telescope find_files" },
                        { icon = "2️⃣ ", desc = " Find Word             ", action = "Telescope live_grep" },
                        { icon = "3️⃣ ", desc = " Recent Files          ", action = "Telescope oldfiles" },
                        { icon = "4️⃣ ", desc = " File Explorer         ", action = "Neotree toggle" },
                        { icon = "5️⃣ ", desc = " Toggle Terminal       ", action = "ToggleTerm" },
                        {
                            icon = "6️⃣ ",
                            desc = " Edit Config           ",
                            action = "edit " .. vim.fn.stdpath("config") .. "/init.lua",
                        }, -- Opens main configuration file (portable)
                        { icon = "7️⃣ ", desc = " Plugin Sync (Lazy)    ", action = "Lazy sync" }, -- Changed from PackerSync to Lazy sync
                        { icon = "8️⃣ ", desc = " LSP Installer (Mason) ", action = "Mason" },
                    },
                    footer = { "May the code be with you, Chochy" },
                },
            })

            -- The autocmd for keymaps must be defined AFTER calling setup
            -- or inside the config function, but outside the setup table.
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "dashboard",
                callback = function()
                    local map = vim.api.nvim_buf_set_keymap
                    local opts = { noremap = true, silent = true, nowait = true }

                    -- Same mappings as before
                    map(0, "n", "1", ":Telescope find_files<CR>", opts)
                    map(0, "n", "2", ":Telescope live_grep<CR>", opts)
                    map(0, "n", "3", ":Telescope oldfiles<CR>", opts)
                    map(0, "n", "4", ":Neotree toggle<CR>", opts)
                    map(0, "n", "5", ":ToggleTerm<CR>", opts)
                    map(0, "n", "6", ":edit " .. vim.fn.stdpath("config") .. "/init.lua<CR>", opts) -- Open config file (portable)
                    map(0, "n", "7", ":Lazy sync<CR>", opts)            -- Changed from PackerSync
                    map(0, "n", "8", ":Mason<CR>", opts)
                end,
            })
        end,
    },
}
