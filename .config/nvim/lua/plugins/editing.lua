-- lua/plugins/editing.lua
return {
    -- Movimiento fácil
    { "easymotion/vim-easymotion", event = "VeryLazy" },
    -- Rodea texto fácilmente (ej. ysiw" para rodear palabra con "")
    { "tpope/vim-surround",        event = "VeryLazy" },
    -- Auto-cierre de paréntesis, comillas, etc.
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter", -- Cargar solo al entrar en modo inserción
        config = function()
            require("nvim-autopairs").setup({})
            -- Integración con nvim-cmp si está presente
            local cmp_ok, cmp = pcall(require, "cmp")
            if cmp_ok then
                local cmp_autopairs_ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
                if cmp_autopairs_ok then
                    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
                end
            end
        end,
    },
    -- Comentar código fácilmente (gc, gcc, etc.)
    {
        "numToStr/Comment.nvim",
        event = "VeryLazy", -- O usa 'keys' si tienes mapeos específicos para cargar
        config = function()
            require("Comment").setup()
        end,
    },
    -- Barra de tags (necesita ctags instalado externamente)
    {
        "preservim/tagbar",
        cmd = "TagbarToggle",
    },
    -- Highlight TODO/FIXME/HACK/NOTE en el codigo
    {
        "folke/todo-comments.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
        keys = {
            { "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO comment" },
            { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous TODO comment" },
            { "<leader>xt", "<cmd>Trouble todo<cr>", desc = "TODOs in Trouble" },
        },
    },
}
