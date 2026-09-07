-- LSP management utilities
local M = {}

-- Restart Dart LSP when there are issues
M.restart_dart_lsp = function()
    if vim.bo.filetype ~= "dart" then
        vim.notify("Open a Dart buffer before restarting its LSP", vim.log.levels.WARN)
        return
    end
    require("flutter-tools.lsp").restart()
end

-- Check LSP status
M.check_lsp_status = function()
    local clients = vim.lsp.get_clients()
    if #clients == 0 then
        vim.notify("No active LSP clients", vim.log.levels.WARN)
        return
    end
    for _, client in ipairs(clients) do
        vim.notify(string.format("LSP: %s (id: %d)", client.name, client.id), vim.log.levels.INFO)
    end
end

-- User commands
vim.api.nvim_create_user_command("LspRestartDart", M.restart_dart_lsp, { desc = "Restart Dart LSP" })
vim.api.nvim_create_user_command("LspStatus", M.check_lsp_status, { desc = "Check LSP status" })

return M
