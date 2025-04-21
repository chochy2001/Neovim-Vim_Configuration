return {
    {
        "glepnir/dashboard-nvim",
        event = "VimEnter",                         -- Carga el dashboard cuando Neovim se inicia
        dependencies = { "nvim-tree/nvim-web-devicons" }, -- Necesita devicons para los iconos
        config = function()
            local dashboard = require("dashboard")
            dashboard.setup({
                -- Tu configuración de tema y contenido se mantiene igual
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
                        -- Ajusta la acción para 'Plugin Sync' si usas lazy.nvim
                        { icon = "1️⃣ ", desc = " Find File             ", action = "Telescope find_files" },
                        { icon = "2️⃣ ", desc = " Find Word             ", action = "Telescope live_grep" },
                        { icon = "3️⃣ ", desc = " Recent Files          ", action = "Telescope oldfiles" },
                        { icon = "4️⃣ ", desc = " File Explorer         ", action = "Neotree toggle" },
                        { icon = "5️⃣ ", desc = " Toggle Terminal       ", action = "ToggleTerm" },
                        {
                            icon = "6️⃣ ",
                            desc = " Edit Config           ",
                            action = "edit ~/.config/nvim/lua/plugins.lua",
                        }, -- Asegúrate que esta ruta sea correcta para tu config de lazy
                        { icon = "7️⃣ ", desc = " Plugin Sync (Lazy)    ", action = "Lazy sync" }, -- Cambiado de PackerSync a Lazy sync
                        { icon = "8️⃣ ", desc = " LSP Installer (Mason) ", action = "Mason" },
                    },
                    footer = { "🚀  Que el código te acompañe, Chochy 🧠" },
                },
            })

            -- El autocmd para los keymaps debe definirse DESPUÉS de llamar a setup
            -- o dentro de la función config, pero fuera de la tabla de setup.
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "dashboard",
                callback = function()
                    local map = vim.api.nvim_buf_set_keymap
                    local opts = { noremap = true, silent = true, nowait = true }

                    -- Mismos mapeos que tenías
                    map(0, "n", "1", ":Telescope find_files<CR>", opts)
                    map(0, "n", "2", ":Telescope live_grep<CR>", opts)
                    map(0, "n", "3", ":Telescope oldfiles<CR>", opts)
                    map(0, "n", "4", ":Neotree toggle<CR>", opts)
                    map(0, "n", "5", ":ToggleTerm<CR>", opts)
                    map(0, "n", "6", ":edit ~/.config/nvim/lua/plugins.lua<CR>", opts) -- Verifica esta ruta
                    map(0, "n", "7", ":Lazy sync<CR>", opts)            -- Cambiado de PackerSync
                    map(0, "n", "8", ":Mason<CR>", opts)
                end,
            })
        end,
    },
}
