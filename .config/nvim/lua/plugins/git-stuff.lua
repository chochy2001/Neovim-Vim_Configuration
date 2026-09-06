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
        keys = {
            { "<leader>gsa", function() require("gitsigns").stage_hunk() end, desc = "Git: Stage Add (hunk)" },
            { "<leader>gsr", function() require("gitsigns").reset_hunk() end, desc = "Git: Stage Reset (hunk)" },
            { "<leader>gsu", function() require("gitsigns").stage_hunk() end, desc = "Git: Undo Stage (hunk)" },
            { "<leader>gsp", function() require("gitsigns").preview_hunk() end, desc = "Git: Stage Preview" },
            { "<leader>gn", function() require("gitsigns").nav_hunk("next") end, desc = "Git: Next hunk" },
            { "<leader>gnp", function() require("gitsigns").nav_hunk("prev") end, desc = "Git: Prev hunk" },
        },
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
            vim.keymap.set("n", "<leader>gsu", gs.stage_hunk, vim.tbl_extend("force", opts, { desc = "Git: Undo Stage (hunk)" }))
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
        -- keys here so the first press loads the plugin (not only in config)
        keys = {
            { "<leader>gdo", "<cmd>DiffviewOpen<cr>", desc = "Git: Diff Open" },
            { "<leader>gdq", "<cmd>DiffviewClose<cr>", desc = "Git: Diff Quit" },
            { "<leader>gdh", "<cmd>DiffviewFileHistory<cr>", desc = "Git: Diff History" },
            { "<leader>gdf", "<cmd>DiffviewToggleFiles<cr>", desc = "Git: Diff Files toggle" },
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
            -- NOTE: `gdo/gdq/gdh/gdf` live in the spec `keys` above so the
            -- first press loads the plugin (not duplicated here).
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
        keys = {
            { "<leader>gp", "<cmd>Neogit push<cr>", desc = "Git Push" },
            { "<leader>gl", "<cmd>Neogit pull<cr>", desc = "Git Pull/Load" },
        },
        config = function()
            require("neogit").setup({
                disable_hint = false,
                disable_context_highlighting = false,
                sort_branches = "-committerdate",
                commit_editor = { kind = "split" },
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
        keys = {
            { "<leader>gco", "<Plug>(git-conflict-ours)", desc = "Git: Conflict choose Ours" },
            { "<leader>gct", "<Plug>(git-conflict-theirs)", desc = "Git: Conflict choose Theirs" },
            { "<leader>gcb", "<Plug>(git-conflict-both)", desc = "Git: Conflict choose Both" },
            { "<leader>gcn", "<Plug>(git-conflict-none)", desc = "Git: Conflict choose None" },
        },
        config = function()
            require('git-conflict').setup({
                -- false: plugin defaults (`ct`/`cb`/`c0`) steal native vim
                -- operators on conflict buffers. Use <leader>gc* instead.
                default_mappings = false,
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
