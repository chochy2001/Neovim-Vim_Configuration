return {
    -- Enhanced terminal with development-specific configuration
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        cmd = "ToggleTerm",
        keys = {
            { "<leader>tt", "<cmd>ToggleTerm direction=float<CR>", desc = "Terminal (Main)" },
            -- extras here so the first press loads the plugin (not only in config)
            {
                "<leader>tg",
                function()
                    require("terminals").toggle("lazygit")
                end,
                desc = "LazyGit Terminal",
            },
            {
                "<leader>tn",
                function()
                    require("terminals").toggle("node")
                end,
                desc = "Node Terminal",
            },
            {
                "<leader>tu",
                function()
                    require("terminals").toggle("monitor")
                end,
                desc = "Htop Terminal",
            },
            {
                "<leader>tp",
                function()
                    require("terminals").toggle("python")
                end,
                desc = "Python Terminal",
            },
            {
                "<leader>tF",
                function()
                    require("terminals").toggle("flutter")
                end,
                desc = "Flutter Terminal",
            },
            {
                "<leader>rs",
                function()
                    require("terminals").stop()
                end,
                desc = "Stop Running Process",
            },
            -- `make` is absent on stock Windows: fall back to a hint instead
            -- of a shell error
            {
                "<leader>rb",
                function()
                    if vim.fn.executable("make") == 1 then
                        vim.cmd("!make")
                    else
                        vim.notify(
                            "`make` not found: use <leader>ob (Overseer Build) instead",
                            vim.log.levels.WARN
                        )
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
                    end,
                },
            })

            -- Terminal keymaps - synced with .ideavimrc
            local opts = { silent = true }
            -- Terminal escape - synced with IntelliJ
            vim.keymap.set("t", "jj", "<C-\\><C-n>", opts)
            vim.keymap.set("t", "<C-[><C-[>", "<C-\\><C-n>", opts) -- Double Ctrl+[ as alternative

            -- Window navigation keymaps are already in vim-options.lua - avoid duplicates
        end,
    },

    -- Modern task runner
    {
        "stevearc/overseer.nvim",
        dependencies = { "akinsho/toggleterm.nvim" },
        cmd = { "OverseerRun", "OverseerToggle", "OverseerInfo", "OverseerBuild" },
        -- keys here so the first press loads the plugin (not only in config)
        keys = {
            { "<leader>oo", "<cmd>OverseerToggle<cr>", desc = "Overseer: Toggle" },
            { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Overseer: Run Task" },
            { "<leader>ob", "<cmd>OverseerBuild<cr>", desc = "Overseer: Build" },
            { "<leader>oi", "<cmd>OverseerInfo<cr>", desc = "Overseer: Info/Edit Configurations" },
        },
        opts = {
            templates = { "builtin" },
            strategy = {
                "toggleterm",
                direction = "horizontal",
                auto_scroll = true,
                quit_on_exit = "success",
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

    -- Standalone file runner; all keys load it on first press.
    {
        "CRAG666/code_runner.nvim",
        dependencies = { "akinsho/toggleterm.nvim" },
        cmd = { "RunCode", "RunFile", "RunProject", "RunClose" },
        keys = {
            { "<leader>r", "<cmd>RunCode<cr>", desc = "Run Code" },
            { "<leader>rf", "<cmd>RunFile<cr>", desc = "Run File" },
            { "<leader>rft", "<cmd>RunFile tab<cr>", desc = "Run File in Tab" },
            { "<leader>rp", "<cmd>OverseerRun<cr>", desc = "Run Project Task" },
            { "<leader>rc", "<cmd>RunClose<cr>", desc = "Close Runner" },
        },
        config = function()
            require("code_runner").setup({ mode = "toggleterm", filetype = {} })
            -- Our runner already resolves and quotes paths. Dispatch the rendered
            -- command directly so code_runner cannot expand literal $file/$dir in it.
            local function run(opts)
                local path = vim.api.nvim_buf_get_name(0)
                if path == "" or vim.bo.modified then
                    vim.notify("Save the file before running it", vim.log.levels.WARN)
                    return
                end
                local mode = opts.args ~= "" and opts.args or "toggleterm"
                if not vim.tbl_contains({ "toggleterm", "tab", "term", "float" }, mode) then
                    vim.notify("Runner mode: toggleterm, tab, term or float", vim.log.levels.WARN)
                    return
                end
                if vim.bo.filetype == "lua" or vim.bo.filetype == "vim" then
                    vim.cmd(
                        (vim.bo.filetype == "lua" and "luafile " or "source ") .. vim.fn.fnameescape(path)
                    )
                    return
                end
                local cmd = require("runner").command(vim.bo.filetype, path)
                if cmd then
                    local utils = require("code_runner.utils").new(require("code_runner.options").get())
                    utils:runMode(cmd, "standalone", mode)
                end
            end
            for _, name in ipairs({ "RunCode", "RunFile" }) do
                vim.api.nvim_create_user_command(
                    name,
                    run,
                    { nargs = "?", desc = "Run a saved standalone file" }
                )
            end
            vim.api.nvim_create_user_command("RunProject", function()
                vim.cmd.OverseerRun()
            end, { desc = "Choose a project task" })
            -- code_runner's default RunClose searches its native buffer names;
            -- toggleterm mode uses terminal 1 instead.
            vim.api.nvim_create_user_command("RunClose", function()
                local term = require("toggleterm.terminal").get(1)
                if term and term:is_open() then
                    term:close()
                end
                require("code_runner.utils")
                    .new(require("code_runner.options").get())
                    :close("crunner_standalone")
            end, { desc = "Close the standalone runner terminal" })
        end,
    },
}
