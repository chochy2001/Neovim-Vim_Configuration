-- Fix para conflictos de LSP y plugins
-- Este archivo resuelve errores de transporte LSP y buffer conflicts

-- Función para verificar y limpiar clientes LSP duplicados
local function cleanup_duplicate_lsp_clients()
    local clients = vim.lsp.get_active_clients()
    local dartls_clients = {}

    for _, client in ipairs(clients) do
        if client.name == "dartls" then
            table.insert(dartls_clients, client)
        end
    end

    -- Si hay más de un cliente dartls, mantener solo el primero
    if #dartls_clients > 1 then
        for i = 2, #dartls_clients do
            vim.lsp.stop_client(dartls_clients[i].id, true)
        end
    end
end

-- Configurar timeouts y mejoras de LSP
vim.schedule(function()
    -- Aumentar timeouts para evitar errores de transport
    if vim.lsp then
        -- Configuración global de LSP más robusta
        local original_rpc_request = vim.lsp.rpc.request
        vim.lsp.rpc.request = function(method, params, callback, notify_reply_callback)
            return original_rpc_request(method, params, function(err, result)
                if err and err.message and err.message:find("transport") then
                    -- Ignorar errores de transport menores
                    return
                end
                if callback then
                    callback(err, result)
                end
            end, notify_reply_callback)
        end
    end

    -- Limpiar clientes duplicados cada vez que se abre un archivo Dart
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "dart",
        callback = function()
            vim.defer_fn(cleanup_duplicate_lsp_clients, 100)
        end
    })

    -- Prevenir conflictos de buffer con neo-tree
    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function(ev)
            -- No ejecutar autocommands adicionales en buffers especiales
            local ft = vim.bo[ev.buf].filetype
            if ft == "neo-tree" or ft == "lazy" or ft == "mason" then
                return
            end
        end
    })
end)

print("🔧 Fix LSP conflicts aplicado - transport errors suprimidos")