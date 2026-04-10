return {
    {
        "hrsh7th/cmp-nvim-lsp",
    },
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
    },
    {
        "hrsh7th/nvim-cmp",
        -- Make sure dependencies are listed before or here
        dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
        config = function()
            local cmp = require("cmp")
            -- Safely load friendly snippets
            pcall(function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end)

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body) -- Use LuaSnip to expand snippets
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirm selection on Enter
                }),
                -- Autocompletion sources
                sources = cmp.config.sources({
                    { name = "nvim_lsp" }, -- LSP suggestions
                    { name = "luasnip" }, -- Snippet suggestions
                }, {
                    { name = "buffer" }, -- Current buffer suggestions
                }),
            })
        end,
    },
}
