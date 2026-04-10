return {
    "stevearc/oil.nvim",
    config = function()
        local oil_ok, oil = pcall(require, "oil")
        if not oil_ok then
            vim.notify("Oil.nvim failed to load", vim.log.levels.WARN)
            return
        end

        -- Robust oil configuration
        local setup_ok = pcall(oil.setup, {
            -- Minimal configuration to avoid errors
            default_file_explorer = false,
            columns = {
                "icon",
                "permissions",
                "size",
                "mtime",
            },
            buf_options = {
                buflisted = false,
                bufhidden = "hide",
            },
            win_options = {
                wrap = false,
                signcolumn = "no",
                cursorcolumn = false,
                foldcolumn = "0",
                spell = false,
                list = false,
                conceallevel = 3,
                concealcursor = "nvic",
            },
            delete_to_trash = true,
            skip_confirm_for_simple_edits = false,
            prompt_save_on_select_new_entry = true,
            cleanup_delay_ms = 2000,
            lsp_file_methods = {
                timeout_ms = 1000,
                autosave_changes = false,
            },
            constrain_cursor = "editable",
            watch_for_changes = false,
            keymaps = {
                ["g?"] = "actions.show_help",
                ["<CR>"] = "actions.select",
                ["sv"] = "actions.select_vsplit",
                ["sh"] = "actions.select_split",
                ["<C-t>"] = "actions.select_tab",
                ["<C-p>"] = "actions.preview",
                ["<C-c>"] = "actions.close",
                ["gr"] = "actions.refresh",
                ["-"] = "actions.parent",
                ["_"] = "actions.open_cwd",
                ["`"] = "actions.cd",
                ["~"] = "actions.tcd",
                ["gs"] = "actions.change_sort",
                ["gx"] = "actions.open_external",
                ["g."] = "actions.toggle_hidden",
                ["g\\"] = "actions.toggle_trash",
            },
            view_options = {
                show_hidden = false,
                is_hidden_file = function(name, bufnr)
                    return vim.startswith(name, ".")
                end,
                is_always_hidden = function(name, bufnr)
                    return false
                end,
                sort = {
                    { "type", "asc" },
                    { "name", "asc" },
                },
            },
        })

        if not setup_ok then
            vim.notify("Error configuring Oil.nvim", vim.log.levels.ERROR)
            return
        end

        -- Keymap with error handling using leader
        vim.keymap.set("n", "<leader>-", function()
            local toggle_ok = pcall(oil.toggle_float)
            if not toggle_ok then
                vim.notify("Error opening Oil.nvim", vim.log.levels.ERROR)
            end
        end, { desc = "Oil: Open parent directory" })

        -- Clearer alternative without conflicts
        vim.keymap.set("n", "<leader>oe", function()
            local toggle_ok = pcall(oil.toggle_float)
            if not toggle_ok then
                vim.notify("Error opening Oil.nvim", vim.log.levels.ERROR)
            end
        end, { desc = "Oil: Open File Explorer" })

        print("Oil.nvim configured correctly")
    end,
}
