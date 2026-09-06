return {
    -- Enhanced terminal with development-specific configuration
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        cmd = "ToggleTerm",
        keys = {
            { "<leader>tt", "<cmd>ToggleTerm direction=float<CR>", desc = "Terminal (Main)" },
            -- extras here so the first press loads the plugin (not only in config)
            { "<leader>tg", "<cmd>lua _lazygit_toggle()<CR>", desc = "LazyGit Terminal" },
            { "<leader>tn", "<cmd>lua _node_toggle()<CR>", desc = "Node Terminal" },
            { "<leader>tu", "<cmd>lua _htop_toggle()<CR>", desc = "Htop Terminal" },
            { "<leader>tp", "<cmd>lua _python_toggle()<CR>", desc = "Python Terminal" },
            { "<leader>tF", "<cmd>lua _flutter_toggle()<CR>", desc = "Flutter Terminal" },
            { "<leader>rs", ":lua vim.fn.jobstop(-1)<CR>", desc = "Stop Running Process" },
            -- `make` is absent on stock Windows: fall back to a hint instead
            -- of a shell error
            {
                "<leader>rb",
                function()
                    if vim.fn.executable("make") == 1 then
                        vim.cmd("!make")
                    else
                        vim.notify("`make` not found: use <leader>ob (Overseer Build) instead", vim.log.levels.WARN)
                    end
                end,
                desc = "Build/Sync Project",
            },
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

            -- Process monitor terminal: tasklist on Windows, htop when
            -- available, plain top as a universal fallback (macOS/Linux)
            local sysmon_cmd
            if vim.fn.has("win32") == 1 then
                sysmon_cmd = "tasklist"
            elseif vim.fn.executable("htop") == 1 then
                sysmon_cmd = "htop"
            else
                sysmon_cmd = "top"
            end
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

            -- NOTE: `tg/tn/tu/tp/tF/rs/rb` live in the spec `keys` above so
            -- the first press loads the plugin (not duplicated here).
        end,
    },

    -- Modern task runner
    {
        "stevearc/overseer.nvim",
        cmd = { "OverseerRun", "OverseerToggle", "OverseerInfo", "OverseerBuild" },
        -- keys here so the first press loads the plugin (not only in config)
        keys = {
            { "<leader>oo", "<cmd>OverseerToggle<cr>", desc = "Overseer: Toggle" },
            { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Overseer: Run Task" },
            { "<leader>ob", "<cmd>OverseerBuild<cr>", desc = "Overseer: Build" },
            { "<leader>oi", "<cmd>OverseerInfo<cr>", desc = "Overseer: Info/Edit Configurations" },
        },
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
            -- NOTE: `oo/or/ob/oi` live in the spec `keys` above so the
            -- first press loads the plugin (not duplicated here).
            -- QuickAction and TaskAction commands removed due to infrequent use
        end,
    },

    -- Code Runner for quick execution
    {
        "CRAG666/code_runner.nvim",
        event = "VeryLazy",
        config = function()
            local is_win = vim.fn.has("win32") == 1
            local shell = vim.o.shell:lower()
            local is_pwsh = shell:match("pwsh") ~= nil or shell:match("powershell") ~= nil
            -- Statement chaining per shell: `;` works in pwsh AND Windows
            -- PowerShell 5.1 (where `&` is the call operator, not a chain);
            -- cmd needs ` & `; Unix shells use ` && `.
            local chain = (not is_win and " && ") or (is_pwsh and "; " or " & ")
            -- Native separators + double quotes (valid in cmd, pwsh and sh)
            local sep = is_win and "\\" or "/"
            local tmpdir = (vim.fn.fnamemodify(vim.fn.tempname(), ":h"):gsub("/", sep))
            local function tmpbin(name)
                return '"' .. tmpdir .. sep .. name .. '"'
            end
            local rm_cmd = is_win and "del" or "rm"
            local py_cmd = vim.fn.executable("python3") == 1 and "python3" or "python"
            local exe_ext = is_win and ".exe" or ""
            -- TypeScript: deno when present, plain node otherwise
            local ts_cmd = vim.fn.executable("deno") == 1 and "deno run" or "node"
            local home = vim.uv.os_homedir() or vim.fn.expand("$HOME")

            local filetypes = {
                java = {
                    "cd $dir" .. chain,
                    "javac $fileName" .. chain,
                    "java $fileNameWithoutExt"
                },
                python = py_cmd .. " -u",
                typescript = ts_cmd,
                rust = {
                    "cd $dir" .. chain,
                    "rustc $fileName" .. chain,
                    '"$dir' .. sep .. '$fileNameWithoutExt"' .. exe_ext
                },
                c = function(...)
                    local c_base = {
                        "cd $dir" .. chain,
                        "gcc $fileName -o",
                        tmpbin("$fileNameWithoutExt" .. exe_ext),
                    }
                    local c_exec = {
                        chain .. tmpbin("$fileNameWithoutExt" .. exe_ext) .. chain,
                        rm_cmd .. " " .. tmpbin("$fileNameWithoutExt" .. exe_ext),
                    }
                    vim.ui.input({ prompt = "Add more args:" }, function(input)
                        c_base[4] = input
                        vim.print(vim.tbl_extend("force", c_base, c_exec))
                        require("code_runner.commands").run_from_fn(vim.list_extend(c_base, c_exec))
                    end)
                end,
                cpp = {
                    "cd $dir" .. chain,
                    "g++ $fileName -o " .. tmpbin("$fileNameWithoutExt" .. exe_ext) .. chain,
                    tmpbin("$fileNameWithoutExt" .. exe_ext),
                },
                kotlin = {
                    "cd $dir" .. chain,
                    "kotlinc $fileName -include-runtime -d $fileNameWithoutExt.jar" .. chain,
                    "java -jar $fileNameWithoutExt.jar"
                },
                dart = "dart $fileName",
            }
            -- Swift only where its toolchain can exist (macOS, or anywhere
            -- `swift` is installed); otherwise the runner would just error.
            if vim.fn.has("mac") == 1 or vim.fn.executable("swift") == 1 then
                filetypes.swift = "swift $fileName"
            end

            require('code_runner').setup({
                mode = "toggleterm",
                focus = true,
                startinsert = true,
                filetype = filetypes,
                project = {
                    [home .. sep .. "dev" .. sep .. "flutter" .. sep .. ".*"] = {
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
