return {
    -- Enhanced terminal with development-specific configuration
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        cmd = "ToggleTerm",
        keys = {
            { "<leader>tt", "<cmd>ToggleTerm direction=float<CR>", desc = "Terminal (Main)" },
        },
        config = function()
            require("toggleterm").setup({
                size = function(term)
                    if term.direction == "horizontal" then
                        return vim.o.lines * 0.4
                    elseif term.direction == "vertical" then
                        return vim.o.columns * 0.4
                    end
                end,
                hide_numbers = true,
                shade_filetypes = {},
                shade_terminals = true,
                shading_factor = 2,
                start_in_insert = true,
                insert_mappings = true,
                terminal_mappings = true,
                persist_size = true,
                persist_mode = true,
                direction = "float",
                close_on_exit = true,
                shell = vim.o.shell,
                auto_scroll = true,
                float_opts = {
                    border = "curved",
                    winblend = 3,
                    highlights = {
                        border = "Normal",
                        background = "Normal",
                    },
                    width = function()
                        return math.floor(vim.o.columns * 0.8)
                    end,
                    height = function()
                        return math.floor(vim.o.lines * 0.8)
                    end,
                },
                winbar = {
                    enabled = false,
                    name_formatter = function(term)
                        return term.name
                    end
                },
            })

            -- Terminal keymaps - synced with .ideavimrc
            local opts = { silent = true }
            -- Terminal escape - synced with IntelliJ
            vim.keymap.set("t", "jj", "<C-\\><C-n>", opts)
            vim.keymap.set("t", "<C-[><C-[>", "<C-\\><C-n>", opts) -- Double Ctrl+[ as alternative

            -- Window navigation keymaps are already in vim-options.lua - avoid duplicates

            -- Language-specific terminals
            local Terminal = require('toggleterm.terminal').Terminal

            -- Flutter terminal
            local flutter_term = Terminal:new({
                cmd = "flutter",
                hidden = true,
                direction = "float",
                float_opts = {
                    border = "double",
                },
                on_open = function(term)
                    vim.cmd("startinsert!")
                    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = term.bufnr, noremap = true, silent = true })
                end,
            })

            function _flutter_toggle()
                flutter_term:toggle()
            end

            -- Git terminal
            local lazygit = Terminal:new({
                cmd = "lazygit",
                dir = "git_dir",
                direction = "float",
                float_opts = {
                    border = "double",
                },
                on_open = function(term)
                    vim.cmd("startinsert!")
                    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = term.bufnr, noremap = true, silent = true })
                end,
            })

            function _lazygit_toggle()
                lazygit:toggle()
            end

            -- Node terminal
            local node = Terminal:new({
                cmd = "node",
                hidden = true,
                direction = "float",
            })

            function _node_toggle()
                node:toggle()
            end

            -- Process monitor terminal (htop on Unix, tasklist on Windows)
            local sysmon_cmd = vim.fn.has("win32") == 1 and "tasklist" or "htop"
            local htop = Terminal:new({
                cmd = sysmon_cmd,
                hidden = true,
                direction = "float",
            })

            function _htop_toggle()
                htop:toggle()
            end

            -- Python terminal (python3 on Unix, python on Windows)
            local python_cmd = vim.fn.executable("python3") == 1 and "python3" or "python"
            local python = Terminal:new({
                cmd = python_cmd,
                hidden = true,
                direction = "float",
            })

            function _python_toggle()
                python:toggle()
            end

            -- Keymaps for specific terminals
            vim.keymap.set("n", "<leader>tg", "<cmd>lua _lazygit_toggle()<CR>", { desc = "LazyGit Terminal" })
            vim.keymap.set("n", "<leader>tn", "<cmd>lua _node_toggle()<CR>", { desc = "Node Terminal" })
            vim.keymap.set("n", "<leader>tu", "<cmd>lua _htop_toggle()<CR>", { desc = "Htop Terminal" })
            vim.keymap.set("n", "<leader>tp", "<cmd>lua _python_toggle()<CR>", { desc = "Python Terminal" })
            vim.keymap.set("n", "<leader>tF", "<cmd>lua _flutter_toggle()<CR>", { desc = "Flutter Terminal" })

            -- Build/Run/Debug (runner keymaps defined in code_runner below)
            vim.keymap.set("n", "<leader>rs", ":lua vim.fn.jobstop(-1)<CR>", { desc = "Stop Running Process" })
            vim.keymap.set("n", "<leader>rb", ":!make<CR>", { desc = "Build/Sync Project" })
        end,
    },

    -- Modern task runner
    {
        "stevearc/overseer.nvim",
        cmd = { "OverseerRun", "OverseerToggle", "OverseerInfo", "OverseerBuild" },
        opts = {
            templates = { "builtin", "user.cpp_build", "user.run_script" },
            strategy = {
                "toggleterm",
                direction = "horizontal",
                auto_scroll = true,
                quit_on_exit = "success"
            },
            component_aliases = {
                default = {
                    { "display_duration", detail_level = 2 },
                    "on_output_summarize",
                    "on_exit_set_status",
                    "on_complete_notify",
                    "on_complete_dispose",
                },
            },
        },
        config = function(_, opts)
            require("overseer").setup(opts)

            -- Keymaps for overseer
            -- Overseer: simplified essential commands
            vim.keymap.set("n", "<leader>oo", "<cmd>OverseerToggle<cr>", { desc = "Overseer: Toggle" })
            vim.keymap.set("n", "<leader>or", "<cmd>OverseerRun<cr>", { desc = "Overseer: Run Task" })
            vim.keymap.set("n", "<leader>ob", "<cmd>OverseerBuild<cr>", { desc = "Overseer: Build" })
            -- ADDED: missing Overseer command for full sync
            vim.keymap.set("n", "<leader>oi", "<cmd>OverseerInfo<cr>", { desc = "Overseer: Info/Edit Configurations" })
            -- QuickAction and TaskAction commands removed due to infrequent use
        end,
    },

    -- Code Runner for quick execution
    {
        "CRAG666/code_runner.nvim",
        event = "VeryLazy",
        config = function()
            local is_win = vim.fn.has("win32") == 1
            local tmpdir = vim.fn.fnamemodify(vim.fn.tempname(), ":h")
            local chain = is_win and " & " or " && "
            local rm_cmd = is_win and "del" or "rm"
            local py_cmd = vim.fn.executable("python3") == 1 and "python3" or "python"
            local exe_ext = is_win and ".exe" or ""

            require('code_runner').setup({
                mode = "toggle",
                focus = true,
                startinsert = true,
                filetype = {
                    java = {
                        "cd $dir" .. chain,
                        "javac $fileName" .. chain,
                        "java $fileNameWithoutExt"
                    },
                    python = py_cmd .. " -u",
                    typescript = "deno run",
                    rust = {
                        "cd $dir" .. chain,
                        "rustc $fileName" .. chain,
                        "$dir/$fileNameWithoutExt" .. exe_ext
                    },
                    c = function(...)
                        local c_base = {
                            "cd $dir" .. chain,
                            "gcc $fileName -o",
                            tmpdir .. "/$fileNameWithoutExt" .. exe_ext,
                        }
                        local c_exec = {
                            chain .. tmpdir .. "/$fileNameWithoutExt" .. exe_ext .. chain,
                            rm_cmd .. " " .. tmpdir .. "/$fileNameWithoutExt" .. exe_ext,
                        }
                        vim.ui.input({ prompt = "Add more args:" }, function(input)
                            c_base[4] = input
                            vim.print(vim.tbl_extend("force", c_base, c_exec))
                            require("code_runner.commands").run_from_fn(vim.list_extend(c_base, c_exec))
                        end)
                    end,
                    cpp = {
                        "cd $dir" .. chain,
                        "g++ $fileName -o " .. tmpdir .. "/$fileNameWithoutExt" .. exe_ext .. chain,
                        tmpdir .. "/$fileNameWithoutExt" .. exe_ext,
                    },
                    kotlin = {
                        "cd $dir" .. chain,
                        "kotlinc $fileName -include-runtime -d $fileNameWithoutExt.jar" .. chain,
                        "java -jar $fileNameWithoutExt.jar"
                    },
                    swift = "swift $fileName",
                    dart = "dart $fileName",
                },
                project = {
                    [vim.fn.expand("~") .. "/dev/flutter/.*"] = {
                        name = "Flutter Project",
                        description = "Run Flutter app",
                        command = "flutter run"
                    },
                },
            })

            -- Code runner keymaps
            vim.keymap.set('n', '<leader>r', ':RunCode<CR>', { desc = "Run Code" })
            vim.keymap.set('n', '<leader>rf', ':RunFile<CR>', { desc = "Run File" })
            vim.keymap.set('n', '<leader>rft', ':RunFile tab<CR>', { desc = "Run File in Tab" })
            vim.keymap.set('n', '<leader>rp', ':RunProject<CR>', { desc = "Run Project" })
            vim.keymap.set('n', '<leader>rc', ':RunClose<CR>', { desc = "Close Runner" })
            -- CRFiletype and CRProjects commands removed as redundant
        end
    },
}
