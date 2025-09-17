-- Utilidades para manejo del LSP
local M = {}

-- Función para reiniciar LSP de Dart cuando hay problemas
M.restart_dart_lsp = function()
    local clients = vim.lsp.get_active_clients({ name = "dartls" })
    for _, client in ipairs(clients) do
        vim.lsp.stop_client(client.id, true)
    end

    vim.defer_fn(function()
        vim.cmd("LspRestart")
        vim.notify("Dart LSP reiniciado", vim.log.levels.INFO)
    end, 1000)
end

-- Función para verificar estado del LSP
M.check_lsp_status = function()
    local clients = vim.lsp.get_active_clients()
    if #clients == 0 then
        vim.notify("No hay clientes LSP activos", vim.log.levels.WARN)
        return
    end

    for _, client in ipairs(clients) do
        vim.notify(string.format("LSP activo: %s (id: %d)", client.name, client.id), vim.log.levels.INFO)
    end
end

-- Función para limpiar errores de transport
M.suppress_transport_errors = function()
    local original_notify = vim.notify
    vim.notify = function(msg, level, opts)
        -- Filtrar errores de transport conocidos
        if type(msg) == "string" and (
            msg:find("transport") or
            msg:find("ENOTDIR") or
            msg:find("language.server") or
            msg:find("spawning language server")
        ) then
            return -- Suprimir estos errores
        end
        return original_notify(msg, level, opts)
    end
end

-- Crear comandos de usuario
vim.api.nvim_create_user_command("LspRestartDart", M.restart_dart_lsp, { desc = "Restart Dart LSP" })
vim.api.nvim_create_user_command("LspStatus", M.check_lsp_status, { desc = "Check LSP status" })
vim.api.nvim_create_user_command("LspSuppressErrors", M.suppress_transport_errors, { desc = "Suppress transport errors" })

return M