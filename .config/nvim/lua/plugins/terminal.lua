return {
    -- Terminal mejorado con configuración específica para desarrollo
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

            -- Terminal keymaps - sincronizado con .ideavimrc
            local opts = { silent = true }
            -- Terminal escape - sincronizado con IntelliJ
            vim.keymap.set("t", "jj", "<C-\\><C-n>", opts)
            vim.keymap.set("t", "<C-[><C-[>", "<C-\\><C-n>", opts) -- Ctrl+[ doble como alternativa

            -- Window navigation keymaps ya están en vim-options.lua - evitar duplicados

            -- Terminales específicos para lenguajes
            local Terminal = require('toggleterm.terminal').Terminal

            -- Terminal para Flutter
            local flutter_term = Terminal:new({
                cmd = "flutter",
                hidden = true,
                direction = "float",
                float_opts = {
                    border = "double",
                },
                on_open = function(term)
                    vim.cmd("startinsert!")
                    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
                end,
            })

            function _flutter_toggle()
                flutter_term:toggle()
            end

            -- Terminal para Git
            local lazygit = Terminal:new({
                cmd = "lazygit",
                dir = "git_dir",
                direction = "float",
                float_opts = {
                    border = "double",
                },
                on_open = function(term)
                    vim.cmd("startinsert!")
                    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
                end,
            })

            function _lazygit_toggle()
                lazygit:toggle()
            end

            -- Terminal para node
            local node = Terminal:new({
                cmd = "node",
                hidden = true,
                direction = "float",
            })

            function _node_toggle()
                node:toggle()
            end

            -- Terminal para htop
            local htop = Terminal:new({
                cmd = "htop",
                hidden = true,
                direction = "float",
            })

            function _htop_toggle()
                htop:toggle()
            end

            -- Terminal para Python
            local python = Terminal:new({
                cmd = "python3",
                hidden = true,
                direction = "float",
            })

            function _python_toggle()
                python:toggle()
            end

            -- Keymaps para terminales específicos
            vim.keymap.set("n", "<leader>tg", "<cmd>lua _lazygit_toggle()<CR>", { desc = "LazyGit Terminal" })
            vim.keymap.set("n", "<leader>tn", "<cmd>lua _node_toggle()<CR>", { desc = "Node Terminal" })
            vim.keymap.set("n", "<leader>tu", "<cmd>lua _htop_toggle()<CR>", { desc = "Htop Terminal" })
            vim.keymap.set("n", "<leader>tp", "<cmd>lua _python_toggle()<CR>", { desc = "Python Terminal" })
            vim.keymap.set("n", "<leader>tF", "<cmd>lua _flutter_toggle()<CR>", { desc = "Flutter Terminal" })

            -- AGREGADOS: Build/Run/Debug commands para sincronización completa
            vim.keymap.set("n", "<leader>rr", ":RunCode<CR>", { desc = "Run Class/File" })
            vim.keymap.set("n", "<leader>rd", ":lua print('Debug not implemented in terminal context')<CR>", { desc = "Debug (placeholder)" })
            vim.keymap.set("n", "<leader>rs", ":lua vim.fn.jobstop(-1)<CR>", { desc = "Stop Running Process" })
            vim.keymap.set("n", "<leader>rb", ":!make<CR>", { desc = "Build/Sync Project" })
        end,
    },

    -- Task runner moderno
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

            -- Keymaps para overseer
            -- Overseer: comandos esenciales simplificados
            vim.keymap.set("n", "<leader>oo", "<cmd>OverseerToggle<cr>", { desc = "Overseer: Toggle" })
            vim.keymap.set("n", "<leader>or", "<cmd>OverseerRun<cr>", { desc = "Overseer: Run Task" })
            vim.keymap.set("n", "<leader>ob", "<cmd>OverseerBuild<cr>", { desc = "Overseer: Build" })
            -- AGREGADO: comando Overseer faltante para sincronización completa
            vim.keymap.set("n", "<leader>oi", "<cmd>OverseerInfo<cr>", { desc = "Overseer: Info/Edit Configurations" })
            -- Comandos QuickAction y TaskAction eliminados por uso poco frecuente
        end,
    },

    -- Code Runner para ejecución rápida
    {
        "CRAG666/code_runner.nvim",
        event = "VeryLazy",
        config = function()
            require('code_runner').setup({
                mode = "toggle",
                focus = true,
                startinsert = true,
                filetype = {
                    java = {
                        "cd $dir &&",
                        "javac $fileName &&",
                        "java $fileNameWithoutExt"
                    },
                    python = "python3 -u",
                    typescript = "deno run",
                    rust = {
                        "cd $dir &&",
                        "rustc $fileName &&",
                        "$dir/$fileNameWithoutExt"
                    },
                    c = function(...)
                        local c_base = {
                            "cd $dir &&",
                            "gcc $fileName -o",
                            "/tmp/$fileNameWithoutExt",
                        }
                        local c_exec = {
                            "&& /tmp/$fileNameWithoutExt &&",
                            "rm /tmp/$fileNameWithoutExt",
                        }
                        vim.ui.input({ prompt = "Add more args:" }, function(input)
                            c_base[4] = input
                            vim.print(vim.tbl_extend("force", c_base, c_exec))
                            require("code_runner.commands").run_from_fn(vim.list_extend(c_base, c_exec))
                        end)
                    end,
                    cpp = {
                        "cd $dir &&",
                        "g++ $fileName -o /tmp/$fileNameWithoutExt &&",
                        "/tmp/$fileNameWithoutExt"
                    },
                    kotlin = {
                        "cd $dir &&",
                        "kotlinc $fileName -include-runtime -d $fileNameWithoutExt.jar &&",
                        "java -jar $fileNameWithoutExt.jar"
                    },
                    swift = "swift $fileName",
                    dart = "dart $fileName",
                },
                project = {
                    ["~/dev/flutter/.*"] = {
                        name = "Flutter Project",
                        description = "Run Flutter app",
                        command = "flutter run"
                    },
                    ["~/.*%.xcodeproj"] = {
                        name = "Xcode Project",
                        description = "Build with xcodebuild",
                        command = "xcodebuild -project $dir -scheme $scheme"
                    },
                },
            })

            -- Keymaps para code runner
            vim.keymap.set('n', '<leader>r', ':RunCode<CR>', { desc = "Run Code" })
            vim.keymap.set('n', '<leader>rf', ':RunFile<CR>', { desc = "Run File" })
            vim.keymap.set('n', '<leader>rft', ':RunFile tab<CR>', { desc = "Run File in Tab" })
            vim.keymap.set('n', '<leader>rp', ':RunProject<CR>', { desc = "Run Project" })
            vim.keymap.set('n', '<leader>rc', ':RunClose<CR>', { desc = "Close Runner" })
            -- Comandos CRFiletype y CRProjects eliminados por ser redundantes
        end
    },
}
