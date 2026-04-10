-- lua/plugins/treesitter.lua (ADDING RAINBOW DELIMITERS)
return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "nvim-treesitter/playground",
            "hiphish/rainbow-delimiters.nvim", -- <-- ADDED
        },
        config = function()
            local ts_configs = require("nvim-treesitter.configs")
            ts_configs.setup({
                -- Optimized parsers: only languages you actively use
                ensure_installed = {
                    "lua", "vim", "vimdoc", "query", -- Nvim essentials
                    "dart", "swift", "kotlin", "c", "cpp", "go", -- Main languages
                    "json", "yaml", "markdown", "bash", -- Configs and scripts
                    -- Removed: javascript, typescript, tsx, html, css, python, rust, java
                    -- To add more languages use: :TSInstall <language>
                },
                sync_install = false,
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
                -- You do NOT need the 'rainbow' section here for rainbow-delimiters
            })

            -- rainbow-delimiters specific configuration (OPTIONAL, uses defaults if not set)
            -- Must be done AFTER loading Treesitter
            -- You could put it in a `vim.defer_fn` or trust it loads via dependency
            pcall(require, "rainbow-delimiters.setup") -- Calls the rainbow plugin setup
        end,
    },
    -- Already listed as dependency above
    -- { "hiphish/rainbow-delimiters.nvim" }
}
