return {
    -- NOTE: telescope-file-browser.nvim was removed: the extension was
    -- never loaded (neo-tree + oil already cover file browsing).
    {
        "nvim-telescope/telescope.nvim",
        tag = "v0.2.2",
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- Nested: load with telescope, not at startup
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = (function()
                    if vim.fn.executable("make") == 1 then
                        return "make"
                    end
                    if vim.fn.executable("cmake") == 1 then
                        return "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release"
                    end
                    return nil
                end)(),
                cond = function()
                    return vim.fn.executable("make") == 1 or vim.fn.executable("cmake") == 1
                end,
            },
            "nvim-telescope/telescope-ui-select.nvim",
        },
        -- Load on demand (command or any finder key) instead of at startup
        cmd = "Telescope",
        keys = {
            { "<leader>ff", desc = "Find Files" },
            { "<leader>fg", desc = "Find Grep" },
            { "<leader>fo", desc = "Find Old Files" },
            { "<leader>fb", desc = "Find Buffers" },
            { "<leader>fh", desc = "Find Help" },
            { "<leader>fc", desc = "Find Commands" },
            { "<leader>fk", desc = "Find Keymaps" },
            { "<leader>ps", desc = "Find Project Symbols" },
            { "<leader>.", desc = "Quick Find Files" },
        },
        config = function()
            require("telescope").setup({
                defaults = {
                    file_ignore_patterns = { "node_modules", ".git/" },
                    -- Use rg when present (install it: `winget install
                    -- BurntSushi.ripgrep.MSVC`, `brew install ripgrep`).
                    -- Fallback is plain grep WITHOUT `--column` (GNU/BSD grep
                    -- has no such flag); on systems with neither, live_grep
                    -- shows a one-time hint instead of erroring.
                    vimgrep_arguments = (function()
                        if vim.fn.executable("rg") == 1 then
                            return {
                                "rg",
                                "--color=never",
                                "--no-heading",
                                "--with-filename",
                                "--line-number",
                                "--column",
                                "--smart-case",
                                "--hidden",
                            }
                        end
                        if vim.fn.executable("grep") == 1 then
                            vim.schedule(function()
                                vim.notify(
                                    "telescope: `rg` not found, live_grep uses plain grep (install ripgrep for best results)",
                                    vim.log.levels.WARN
                                )
                            end)
                            return {
                                "grep",
                                "--color=never",
                                "--with-filename",
                                "--line-number",
                                "--extended-regexp",
                            }
                        end
                        return nil
                    end)(),
                    -- Enable treesitter syntax highlighting in preview
                    preview = {
                        treesitter = true,
                    },
                },
                pickers = {
                    find_files = {
                        previewer = true,
                    },
                    live_grep = {
                        previewer = true,
                    },
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
            })
            local builtin = require("telescope.builtin")
            -- Unified Find/Files category with <leader>f* prefix
            vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find Grep" })
            vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Find Old Files" })
            vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
            vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find Help" })
            vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "Find Commands" })
            vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Find Keymaps" })

            -- Project/Symbol search - synced with .ideavimrc
            vim.keymap.set("n", "<leader>ps", builtin.lsp_dynamic_workspace_symbols, { desc = "Find Project Symbols" })

            -- REMOVED: <leader><leader> conflicts with clear search highlight from .ideavimrc
            -- REMOVED: <leader>fd unnecessary duplicate

            -- Additional mappings that work well
            vim.keymap.set("n", "<leader>.", builtin.find_files, { desc = "Quick Find Files" })
            vim.keymap.set("n", ",,", builtin.find_files, { desc = "Quick Find Files" })

            -- Load extensions
            require("telescope").load_extension("ui-select")
            -- Load fzf if available
            pcall(function()
                require("telescope").load_extension("fzf")
            end)
        end,
    },
}
