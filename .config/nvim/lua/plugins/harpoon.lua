-- Final and clean content for: lua/plugins/harpoon.lua
return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2", -- Using branch 'harpoon2' because it contains the modern API
                            -- required by our configuration. Version v1 has a different
                            -- and incompatible API. Update to a specific tag when
                            -- harpoon2 has a stable release to avoid breaking changes.
        dependencies = { "nvim-lua/plenary.nvim" },
        -- Restore lazy loading by user's original keys
        keys = {
            { "<leader>ma", desc = "Harpoon: Add File" },
            { "<leader>mh", desc = "Harpoon: Toggle UI" },
            { "<leader>1", desc = "Harpoon: Go To 1" },
            { "<leader>2", desc = "Harpoon: Go To 2" },
            { "<leader>3", desc = "Harpoon: Go To 3" },
            { "<leader>4", desc = "Harpoon: Go To 4" },
            { "<leader>5", desc = "Harpoon: Go To 5" },
            { "<leader>6", desc = "Harpoon: Go To 6" },
            { "<leader>7", desc = "Harpoon: Go To 7" },
            { "<leader>8", desc = "Harpoon: Go To 8" },
            { "<leader>9", desc = "Harpoon: Go To 9" },
            { "<leader>mp", desc = "Harpoon: Previous" },
            { "<leader>mn", desc = "Harpoon: Next" },
        },
        config = function()
            -- Require harpoon here
            local harpoon = require("harpoon")

            -- Required setup call
            harpoon:setup() -- Using ':' as confirmed working

            -- User keymaps with the corrected API
            local map = vim.keymap.set
            -- Common options for keymaps (noremap=true is default in lua)
            local opts = { silent = true }

            -- Add file (changed to <leader>ma for Marks category)
            map("n", "<leader>ma", function()
                -- Get list object and call its :add method
                harpoon:list():add()
            end, { desc = "Harpoon: Add File", silent = true })

            -- Show/hide menu (changed to <leader>mh to avoid conflict with bookmarks)
            map("n", "<leader>mh", function()
                -- Get list object and pass it to toggle_quick_menu
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end, { desc = "Harpoon: Toggle UI", silent = true })

            -- Select files 1-9
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

            -- Navigate previous/next
            map("n", "<leader>mp", function()
                harpoon:list():prev()
            end, { desc = "Harpoon: Previous", silent = true })

            map("n", "<leader>mn", function()
                harpoon:list():next()
            end, { desc = "Harpoon: Next", silent = true })
        end,
    },
}
