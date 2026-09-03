-- Content for: lua/plugins/undotree.lua
return {
    {
        "mbbill/undotree",
        -- Lazy loading: the plugin will load the first time
        -- the :UndotreeToggle command is executed (either manually
        -- or through the keyboard shortcut).
        cmd = "UndotreeToggle",
        -- keys here (not only in config) so the FIRST press loads the plugin
        keys = {
            { "<leader>u", ":UndotreeToggle<CR>", desc = "Toggle Undotree" },
        },
        config = function()
            -- (Optional) You can configure undotree global variables here if needed
            -- Example: vim.g.undotree_WindowLayout = 2 -- Changes the window layout
            -- Example: vim.g.undotree_SetFocusWhenToggle = 1 -- Focuses the undotree window when opened
            -- NOTE: the `<leader>u` keymap lives in the spec `keys` above so the
            -- first press loads the plugin (defining it only here would never fire).
        end,
        -- We don't need the 'keys' table explicitly here because 'cmd' already handles
        -- lazy loading when the command is invoked from the keymap.
    },
}
