-- ULTRA MINIMAL configuration - guaranteed NO E5248 errors
return {
    {
        "nvim-tree/nvim-web-devicons",
        lazy = false,
        priority = 1000,
        config = function()
            -- MINIMAL configuration - only uses plugin default icons
            require("nvim-web-devicons").setup({
                default = true,
                color_icons = true,
                strict = false,
                -- NO overrides - use ONLY what comes by default
            })
        end,
    },
}