return {
    -- Fugitive con keymaps mejorados
    {
        "tpope/vim-fugitive",
        cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse", "GRemove", "GRename", "Glgrep", "Gedit" },
        ft = {"fugitive"},
        keys = {
            { "<leader>gs", "<cmd>Git<cr>", desc = "Git Status" },
            { "<leader>gw", "<cmd>Gwrite<cr>", desc = "Git Write" },
            { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git Commit" },
            { "<leader>gd", "<cmd>Gdiffsplit<cr>", desc = "Git Diff Split" },
            { "<leader>gB", "<cmd>Git blame<cr>", desc = "Git Blame" },
            { "<leader>gb", "<cmd>GBrowse<cr>", desc = "Git Browse" },
        }
    },

    -- GitSigns mejorado con configuración completa
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("gitsigns").setup({
                signs = {
                    add          = { text = '│' },
                    change       = { text = '│' },
                    delete       = { text = '_' },
                    topdelete    = { text = '‾' },
                    changedelete = { text = '~' },
                    untracked    = { text = '┆' },
                },
                signcolumn = true,
                numhl      = false,
                linehl     = false,
                word_diff  = false,
                watch_gitdir = { follow_files = true },
                auto_attach = true,
                attach_to_untracked = false,
                current_line_blame = false,
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = 'eol',
                    delay = 1000,
                    ignore_whitespace = false,
                    virt_text_priority = 100,
                },
                current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
                sign_priority = 6,
                update_debounce = 100,
                status_formatter = nil,
                max_file_length = 40000,
                preview_config = {
                    border = 'single',
                    style = 'minimal',
                    relative = 'cursor',
                    row = 0,
                    col = 1
                },
            })

            -- Keymaps mejorados para GitSigns
            local gs = require("gitsigns")
            local opts = { silent = true }

            -- Navigation
            vim.keymap.set("n", "]c", function()
                if vim.wo.diff then return "]c" end
                vim.schedule(function() gs.next_hunk() end)
                return "<Ignore>"
            end, vim.tbl_extend("force", opts, { expr = true, desc = "Git: Next Hunk" }))

            vim.keymap.set("n", "[c", function()
                if vim.wo.diff then return "[c" end
                vim.schedule(function() gs.prev_hunk() end)
                return "<Ignore>"
            end, vim.tbl_extend("force", opts, { expr = true, desc = "Git: Previous Hunk" }))

            -- Actions principales
            vim.keymap.set("n", "<leader>hs", gs.stage_hunk, vim.tbl_extend("force", opts, { desc = "Git: Stage Hunk" }))
            vim.keymap.set("n", "<leader>hr", gs.reset_hunk, vim.tbl_extend("force", opts, { desc = "Git: Reset Hunk" }))
            vim.keymap.set("n", "<leader>hS", gs.stage_buffer, vim.tbl_extend("force", opts, { desc = "Git: Stage Buffer" }))
            vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, vim.tbl_extend("force", opts, { desc = "Git: Undo Stage Hunk" }))
            vim.keymap.set("n", "<leader>hR", gs.reset_buffer, vim.tbl_extend("force", opts, { desc = "Git: Reset Buffer" }))
            vim.keymap.set("n", "<leader>hp", gs.preview_hunk, vim.tbl_extend("force", opts, { desc = "Git: Preview Hunk" }))
            vim.keymap.set("n", "<leader>hb", function() gs.blame_line{full=true} end, vim.tbl_extend("force", opts, { desc = "Git: Blame Line" }))
            vim.keymap.set("n", "<leader>tb", gs.toggle_current_line_blame, vim.tbl_extend("force", opts, { desc = "Git: Toggle Line Blame" }))
            vim.keymap.set("n", "<leader>hd", gs.diffthis, vim.tbl_extend("force", opts, { desc = "Git: Diff This" }))
            vim.keymap.set("n", "<leader>td", gs.toggle_deleted, vim.tbl_extend("force", opts, { desc = "Git: Toggle Deleted" }))

            -- Text object
            vim.keymap.set({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end,
    },

    -- Diffview mejorado
    {
        "sindrets/diffview.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = {
            "DiffviewOpen",
            "DiffviewClose",
            "DiffviewToggleFiles",
            "DiffviewFocusFiles",
            "DiffviewRefresh",
            "DiffviewFileHistory",
        },
        config = function()
            require("diffview").setup({
                diff_binaries = false,
                enhanced_diff_hl = false,
                git_cmd = { "git" },
                use_icons = true,
                show_help_hints = true,
                watch_index = true,
                icons = {
                    folder_closed = "",
                    folder_open = "",
                },
                signs = {
                    fold_closed = "",
                    fold_open = "",
                    done = "✓",
                },
                view = {
                    default = {
                        layout = "diff2_horizontal",
                        disable_diagnostics = true,
                    },
                    merge_tool = {
                        layout = "diff3_horizontal",
                        disable_diagnostics = true,
                    },
                    file_history = {
                        layout = "diff2_horizontal",
                        disable_diagnostics = true,
                    },
                },
            })

            -- Keymaps para Diffview
            vim.keymap.set("n", "<leader>gdo", "<cmd>DiffviewOpen<cr>", { desc = "Git: Open Diffview" })
            vim.keymap.set("n", "<leader>gdc", "<cmd>DiffviewClose<cr>", { desc = "Git: Close Diffview" })
            vim.keymap.set("n", "<leader>gdh", "<cmd>DiffviewFileHistory<cr>", { desc = "Git: File History" })
            vim.keymap.set("n", "<leader>gdf", "<cmd>DiffviewToggleFiles<cr>", { desc = "Git: Toggle Files Panel" })
        end,
    },

    -- Neogit mejorado
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim",
        },
        cmd = "Neogit",
        config = function()
            require("neogit").setup({
                disable_signs = false,
                disable_hint = false,
                disable_context_highlighting = false,
                disable_commit_confirmation = false,
                auto_refresh = true,
                sort_branches = "-committerdate",
                disable_builtin_notifications = false,
                use_magit_keybindings = false,
                commit_popup = {
                    kind = "split",
                },
                console = {
                    kind = "split",
                },
                integrations = {
                    telescope = true,
                    diffview = true,
                },
                signs = {
                    section = { ">", "v" },
                    item = { ">", "v" },
                    hunk = { "", "" },
                },
            })
            vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<CR>", { desc = "Open Neogit" })
            vim.keymap.set("n", "<leader>gc", "<cmd>Neogit commit<CR>", { desc = "Neogit Commit" })
            vim.keymap.set("n", "<leader>gp", "<cmd>Neogit pull<CR>", { desc = "Neogit Pull" })
            vim.keymap.set("n", "<leader>gP", "<cmd>Neogit push<CR>", { desc = "Neogit Push" })
        end,
    },

    -- Git conflict resolution
    {
        "akinsho/git-conflict.nvim",
        version = "*",
        event = "BufReadPre",
        config = function()
            require('git-conflict').setup({
                default_mappings = true,
                default_commands = true,
                disable_diagnostics = false,
                list_opener = 'copen',
                highlights = {
                    incoming = 'DiffAdd',
                    current = 'DiffText',
                }
            })

            -- Keymaps para resolución de conflictos
            vim.keymap.set('n', '<leader>co', '<Plug>(git-conflict-ours)', { desc = "Git Conflict: Choose Ours" })
            vim.keymap.set('n', '<leader>ct', '<Plug>(git-conflict-theirs)', { desc = "Git Conflict: Choose Theirs" })
            vim.keymap.set('n', '<leader>cb', '<Plug>(git-conflict-both)', { desc = "Git Conflict: Choose Both" })
            vim.keymap.set('n', '<leader>c0', '<Plug>(git-conflict-none)', { desc = "Git Conflict: Choose None" })
            vim.keymap.set('n', ']x', '<Plug>(git-conflict-prev-conflict)', { desc = "Git Conflict: Previous" })
            vim.keymap.set('n', '[x', '<Plug>(git-conflict-next-conflict)', { desc = "Git Conflict: Next" })
        end
    },
}
