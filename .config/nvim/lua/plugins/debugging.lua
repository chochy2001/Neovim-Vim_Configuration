-- Debug Adapter Protocol (DAP) for visual debugging
return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            -- UI for DAP
            {
                "rcarriga/nvim-dap-ui",
                dependencies = { "nvim-neotest/nvim-nio" },
                opts = {},
                config = function(_, opts)
                    local dap = require("dap")
                    local dapui = require("dapui")
                    dapui.setup(opts)
                    dap.listeners.after.event_initialized["dapui_config"] = function()
                        dapui.open()
                    end
                    dap.listeners.before.event_terminated["dapui_config"] = function()
                        dapui.close()
                    end
                    dap.listeners.before.event_exited["dapui_config"] = function()
                        dapui.close()
                    end
                end,
            },
            -- Virtual text for variable values
            { "theHamsta/nvim-dap-virtual-text", opts = {} },
        },
        keys = {
            { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
            { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Debug: Conditional Breakpoint" },
            { "<leader>dc", function() require("dap").continue() end, desc = "Debug: Continue" },
            { "<leader>do", function() require("dap").step_over() end, desc = "Debug: Step Over" },
            { "<leader>di", function() require("dap").step_into() end, desc = "Debug: Step Into" },
            { "<leader>dO", function() require("dap").step_out() end, desc = "Debug: Step Out" },
            { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Debug: Toggle REPL" },
            { "<leader>dl", function() require("dap").run_last() end, desc = "Debug: Run Last" },
            { "<leader>dx", function() require("dap").terminate() end, desc = "Debug: Terminate" },
            { "<leader>du", function() require("dapui").toggle() end, desc = "Debug: Toggle UI" },
        },
        config = function()
            local dap = require("dap")

            -- C/C++ adapter (codelldb or lldb-vscode)
            if vim.fn.executable("codelldb") == 1 then
                dap.adapters.codelldb = {
                    type = "server",
                    port = "${port}",
                    executable = {
                        command = "codelldb",
                        args = { "--port", "${port}" },
                    },
                }
                dap.configurations.cpp = {
                    {
                        name = "Launch (codelldb)",
                        type = "codelldb",
                        request = "launch",
                        program = function()
                            return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
                        end,
                        cwd = "${workspaceFolder}",
                        stopOnEntry = false,
                    },
                }
                dap.configurations.c = dap.configurations.cpp
            end

            -- DAP breakpoint signs (use extmarks via highlight groups)
            local dap_signs = {
                DapBreakpoint = { text = "", texthl = "DiagnosticError" },
                DapBreakpointCondition = { text = "", texthl = "DiagnosticWarn" },
                DapStopped = { text = "", texthl = "DiagnosticInfo", linehl = "Visual" },
            }
            for name, opts in pairs(dap_signs) do
                vim.fn.sign_define(name, opts)
            end
        end,
    },
}
