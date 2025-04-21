-- Contenido FINAL y LIMPIO para: lua/plugins/harpoon.lua
return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2", -- Mantener la branch correcta
        dependencies = { "nvim-lua/plenary.nvim" },
        -- Restaurar carga perezosa por teclas originales del usuario
        keys = {
            { "<leader>a", desc = "Harpoon: Add File" },
            { "<leader>h", desc = "Harpoon: Toggle UI" },
            { "<leader>1", desc = "Harpoon: Go To 1" },
            { "<leader>2", desc = "Harpoon: Go To 2" },
            { "<leader>3", desc = "Harpoon: Go To 3" },
            { "<leader>4", desc = "Harpoon: Go To 4" },
            { "<leader>5", desc = "Harpoon: Go To 5" },
            { "<leader>6", desc = "Harpoon: Go To 6" },
            { "<leader>7", desc = "Harpoon: Go To 7" },
            { "<leader>8", desc = "Harpoon: Go To 8" },
            { "<leader>9", desc = "Harpoon: Go To 9" },
            { "<C-S-P>",   desc = "Harpoon: Previous" },
            { "<C-S-N>",   desc = "Harpoon: Next" },
        },
        config = function()
            -- Requerir harpoon aquí
            local harpoon = require("harpoon")

            -- Llamada de configuración requerida
            harpoon:setup() -- Usando ':' como se confirmó que funciona

            -- Mapeos de teclado del usuario con la API corregida
            local map = vim.keymap.set
            -- Opciones comunes para los mapeos (noremap=true es default en lua)
            local opts = { silent = true }

            -- Añadir archivo
            map("n", "<leader>a", function()
                -- Obtener objeto lista y llamar a su método :add
                harpoon:list():add()
            end, { desc = "Harpoon: Add File", silent = true }) -- Añadido silent=true

            -- Mostrar/ocultar menú (con <C-h>)
            map("n", "<leader>h", function()
                -- Obtener objeto lista y pasarlo a toggle_quick_menu
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end, { desc = "Harpoon: Toggle UI", silent = true }) -- Añadido silent=true

            -- Seleccionar archivos 1-9
            map("n", "<leader>1", function()
                harpoon:list():select(1)
            end, { desc = "Harpoon: Go To 1", silent = true })

            map("n", "<leader>2", function()
                harpoon:list():select(2)
            end, { desc = "Harpoon: Go To 2", silent = true })

            map("n", "<leader>3", function()
                harpoon:list():select(3)
            end, { desc = "Harpoon: Go To 3", silent = true })

            map("n", "<leader>4", function()
                harpoon:list():select(4)
            end, { desc = "Harpoon: Go To 4", silent = true })

            map("n", "<leader>5", function()
                harpoon:list():select(5)
            end, { desc = "Harpoon: Go To 5", silent = true })

            map("n", "<leader>6", function()
                harpoon:list():select(6)
            end, { desc = "Harpoon: Go To 6", silent = true })

            map("n", "<leader>7", function()
                harpoon:list():select(7)
            end, { desc = "Harpoon: Go To 7", silent = true })

            map("n", "<leader>8", function()
                harpoon:list():select(8)
            end, { desc = "Harpoon: Go To 8", silent = true })

            map("n", "<leader>9", function()
                harpoon:list():select(9)
            end, { desc = "Harpoon: Go To 9", silent = true })

            -- Navegar anterior/siguiente
            map("n", "<C-S-P>", function()
                harpoon:list():prev()
            end, { desc = "Harpoon: Previous", silent = true })

            map("n", "<C-S-N>", function()
                harpoon:list():next()
            end, { desc = "Harpoon: Next", silent = true })
        end,
    },
}
