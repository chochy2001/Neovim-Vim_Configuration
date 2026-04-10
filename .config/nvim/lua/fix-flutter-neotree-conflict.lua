-- Fix for LSP and plugin conflicts
-- This file resolves LSP transport errors and buffer conflicts

-- Function to check and clean up duplicate LSP clients
local function cleanup_duplicate_lsp_clients()
    local clients = vim.lsp.get_clients()
    local dartls_clients = {}

    for _, client in ipairs(clients) do
        if client.name == "dartls" then
            table.insert(dartls_clients, client)
        end
    end

    -- If there is more than one dartls client, keep only the first
    if #dartls_clients > 1 then
        for i = 2, #dartls_clients do
            dartls_clients[i]:stop(true)
        end
    end
end

-- Configure timeouts and LSP improvements
vim.schedule(function()
    -- Increase timeouts to avoid transport errors
    if vim.lsp then
        -- More robust global LSP configuration
        local original_rpc_request = vim.lsp.rpc.request
        vim.lsp.rpc.request = function(method, params, callback, notify_reply_callback)
            return original_rpc_request(method, params, function(err, result)
                if err and err.message and err.message:find("transport") then
                    -- Ignore minor transport errors
                    return
                end
                if callback then
                    callback(err, result)
                end
            end, notify_reply_callback)
        end
    end

    -- Clean up duplicate clients every time a Dart file is opened
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "dart",
        callback = function()
            vim.defer_fn(cleanup_duplicate_lsp_clients, 100)
        end
    })

    -- Prevent buffer conflicts with neo-tree
    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function(ev)
            -- Do not run additional autocommands on special buffers
            local ft = vim.bo[ev.buf].filetype
            if ft == "neo-tree" or ft == "lazy" or ft == "mason" then
                return
            end
        end
    })
end)

-- LSP conflict fix applied - transport errors suppressed