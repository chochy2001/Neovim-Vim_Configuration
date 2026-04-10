return {
    -- Native FZF for ultra-fast search (requires compilation)
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = (vim.fn.has("win32") == 1 and vim.fn.executable("cmake") == 1)
            and "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release"
            or "make",
        cond = function()
            return vim.fn.executable("make") == 1 or vim.fn.executable("cmake") == 1
        end,
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        -- Load when telescope loads
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        config = function()
            -- file_browser specific configuration if needed
            -- require("telescope").load_extension("file_browser")
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8", -- Updated to latest version
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({
                defaults = {
                    file_ignore_patterns = { "node_modules", ".git/" },
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                        "--hidden",
                    },
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
