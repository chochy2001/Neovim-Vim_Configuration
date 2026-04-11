return {
    -- Fugitive: Git commands core
    {
        "tpope/vim-fugitive",
        cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse", "GRemove", "GRename", "Glgrep", "Gedit" },
        ft = {"fugitive"},
        keys = {
            -- Git Core (2 keys)
            { "<leader>gs", "<cmd>Git<cr>", desc = "Git Status" },
            { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git Commit" },
            { "<leader>gp", "<cmd>Neogit push<cr>", desc = "Git Push" },  -- Moved from gps
            { "<leader>gl", "<cmd>Neogit pull<cr>", desc = "Git Pull/Load" },  -- Moved from gpl
            { "<leader>gf", "<cmd>Git fetch<cr>", desc = "Git Fetch" },
            
            -- Git Blame & Branches (gb*)
            { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git Blame Toggle" },  -- Moved from gv
            { "<leader>gbl", "<cmd>Git blame<cr>", desc = "Git Blame Line" },  -- Line-specific
            { "<leader>gbr", "<cmd>GBrowse<cr>", desc = "Git Branches/Browse" },  -- Moved from gb
            { "<leader>gbc", "<cmd>Git diff HEAD~1<cr>", desc = "Git Branch Compare" },  -- Moved from gcb
            
            -- Git History (gh*)
            { "<leader>gh", "<cmd>Git log --oneline<cr>", desc = "Git History/Log" },  -- Moved from gl
            { "<leader>ghd", "<cmd>Git log --graph --oneline --all<cr>", desc = "Git History Details" },  -- Moved from gC
            
            -- Git Diff (gd*) - kept separate from LSP gd without leader
            { "<leader>gd", "<cmd>Gdiffsplit<cr>", desc = "Git Diff" },  -- Moved from gds
        }
    },

    -- vim-rhubarb: GitHub integration
    {
        "tpope/vim-rhubarb",
        dependencies = { "tpope/vim-fugitive" },
        event = "VeryLazy",
    },

    -- GitSigns: Hunk operations and stage/reset
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

            local gs = require("gitsigns")
            local opts = { silent = true }

            -- ============================================
            -- NEW SYSTEM: Git Stage (gs*) - NO UPPERCASE
            -- ============================================
            
            -- Stage operations (gsa, gsr, gsu, gsp, gsb)
            vim.keymap.set("n", "<leader>gsa", gs.stage_hunk, vim.tbl_extend("force", opts, { desc = "Git: Stage Add (hunk)" }))
            vim.keymap.set("n", "<leader>gsr", gs.reset_hunk, vim.tbl_extend("force", opts, { desc = "Git: Stage Reset (hunk)" }))
            vim.keymap.set("n", "<leader>gsu", function() gs.stage_hunk() end, vim.tbl_extend("force", opts, { desc = "Git: Stage Undo (toggle)" }))
            vim.keymap.set("n", "<leader>gsp", gs.preview_hunk, vim.tbl_extend("force", opts, { desc = "Git: Stage Preview" }))
            vim.keymap.set("n", "<leader>gsb", gs.reset_buffer, vim.tbl_extend("force", opts, { desc = "Git: Stage Buffer reset" }))
            
            -- Hunk navigation (gn, gnp)
            vim.keymap.set("n", "<leader>gn", function()
                if vim.wo.diff then return "]c" end
                vim.schedule(function() gs.nav_hunk("next") end)
                return "<Ignore>"
            end, vim.tbl_extend("force", opts, { expr = true, desc = "Git: Next hunk" }))

            vim.keymap.set("n", "<leader>gnp", function()
                if vim.wo.diff then return "[c" end
                vim.schedule(function() gs.nav_hunk("prev") end)
                return "<Ignore>"
            end, vim.tbl_extend("force", opts, { expr = true, desc = "Git: Prev hunk" }))

            -- Git Diff Local (gdl)
            vim.keymap.set("n", "<leader>gdl", gs.diffthis, vim.tbl_extend("force", opts, { desc = "Git: Diff Local changes" }))
            
            -- Toggle blame line
            vim.keymap.set("n", "<leader>gbt", gs.toggle_current_line_blame, vim.tbl_extend("force", opts, { desc = "Git: Blame Toggle inline" }))

            -- Text object for visual mode
            vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git: Select Hunk" })
        end,
    },

    -- Diffview: Visual diff tool
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

            -- Diffview commands (gd*)
            vim.keymap.set("n", "<leader>gdo", "<cmd>DiffviewOpen<cr>", { desc = "Git: Diff Open" })
            vim.keymap.set("n", "<leader>gdq", "<cmd>DiffviewClose<cr>", { desc = "Git: Diff Quit" })
            vim.keymap.set("n", "<leader>gdh", "<cmd>DiffviewFileHistory<cr>", { desc = "Git: Diff History" })
            vim.keymap.set("n", "<leader>gdf", "<cmd>DiffviewToggleFiles<cr>", { desc = "Git: Diff Files toggle" })
        end,
    },

    -- Neogit: Magit-like interface
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
            
            -- Neogit does not need additional keymaps (we use gp/gl defined above)
        end,
    },

    -- Git Conflict: Merge conflict resolution
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

            -- Git Conflict commands (gc*)
            vim.keymap.set('n', '<leader>gco', '<Plug>(git-conflict-ours)', { desc = "Git: Conflict choose Ours" })
            vim.keymap.set('n', '<leader>gct', '<Plug>(git-conflict-theirs)', { desc = "Git: Conflict choose Theirs" })
            vim.keymap.set('n', '<leader>gcb', '<Plug>(git-conflict-both)', { desc = "Git: Conflict choose Both" })
            vim.keymap.set('n', '<leader>gcn', '<Plug>(git-conflict-none)', { desc = "Git: Conflict choose None" })
            vim.keymap.set('n', '<leader>gcp', '<Plug>(git-conflict-prev-conflict)', { desc = "Git: Conflict Previous" })
            vim.keymap.set('n', '<leader>gcnn', '<Plug>(git-conflict-next-conflict)', { desc = "Git: Conflict Next" })
        end
    },
}
