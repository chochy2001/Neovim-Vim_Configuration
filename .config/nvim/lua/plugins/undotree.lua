-- Content for: lua/plugins/undotree.lua
return {
    {
        "mbbill/undotree",
        -- Lazy loading: The plugin will load the first time
        -- the :UndotreeToggle command is executed (either manually
        -- or through the keyboard shortcut).
        cmd = "UndotreeToggle",
        config = function()
            -- Keyboard shortcut to show/hide undotree
            vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>", {
                desc = "Toggle Undotree", -- Optional description for which-key and others
                noremap = true,
                silent = true,
            })

            -- (Optional) You can configure undotree global variables here if needed
            -- Example: vim.g.undotree_WindowLayout = 2 -- Changes the window layout
            -- Example: vim.g.undotree_SetFocusWhenToggle = 1 -- Focuses the undotree window when opened
        end,
        -- We don't need the 'keys' table explicitly here because 'cmd' already handles
        -- lazy loading when the command is invoked from the keymap.
    },
}
