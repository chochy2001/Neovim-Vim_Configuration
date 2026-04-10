-- LSP management utilities
local M = {}

-- Function to restart Dart LSP when there are issues
M.restart_dart_lsp = function()
    local clients = vim.lsp.get_clients({ name = "dartls" })
    for _, client in ipairs(clients) do
        client:stop(true)
    end

    vim.defer_fn(function()
        vim.cmd("LspRestart")
        vim.notify("Dart LSP restarted", vim.log.levels.INFO)
    end, 1000)
end

-- Function to check LSP status
M.check_lsp_status = function()
    local clients = vim.lsp.get_clients()
    if #clients == 0 then
        vim.notify("No active LSP clients", vim.log.levels.WARN)
        return
    end

    for _, client in ipairs(clients) do
        vim.notify(string.format("LSP active: %s (id: %d)", client.name, client.id), vim.log.levels.INFO)
    end
end

-- Function to clean up transport errors
M.suppress_transport_errors = function()
    local original_notify = vim.notify
    vim.notify = function(msg, level, opts)
        -- Filter known transport errors
        if type(msg) == "string" and (
            msg:find("transport") or
            msg:find("ENOTDIR") or
            msg:find("language.server") or
            msg:find("spawning language server")
        ) then
            return -- Suppress these errors
        end
        return original_notify(msg, level, opts)
    end
end

-- Create user commands
vim.api.nvim_create_user_command("LspRestartDart", M.restart_dart_lsp, { desc = "Restart Dart LSP" })
vim.api.nvim_create_user_command("LspStatus", M.check_lsp_status, { desc = "Check LSP status" })
vim.api.nvim_create_user_command("LspSuppressErrors", M.suppress_transport_errors, { desc = "Suppress transport errors" })

return M