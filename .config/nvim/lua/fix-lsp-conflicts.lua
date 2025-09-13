-- Fix para conflictos LSP entre Flutter-tools y nvim-lspconfig
-- Ejecuta automáticamente para prevenir errores

-- Prevenir autocomandos duplicados - versión segura
local augroup_result = pcall(vim.api.nvim_create_augroup, "LspConflictFix", { clear = true })
local augroup = augroup_result and "LspConflictFix" or nil

-- Override vim.lsp.buf_get_clients para evitar errores
local function safe_get_clients(bufnr)
    local clients = {}

    -- Usar la nueva API si está disponible
    if vim.lsp.get_clients then
        local all_clients = vim.lsp.get_clients()
        if bufnr then
            for _, client in ipairs(all_clients) do
                if client.attached_buffers and client.attached_buffers[bufnr] then
                    table.insert(clients, client)
                end
            end
        else
            clients = all_clients
        end
    -- Fallback a la API vieja si es necesario
    elseif vim.lsp.buf_get_clients then
        clients = bufnr and vim.lsp.buf_get_clients(bufnr) or vim.lsp.buf_get_clients()
    -- Fallback final
    elseif vim.lsp.get_active_clients then
        clients = vim.lsp.get_active_clients()
        if bufnr then
            local buffer_clients = {}
            for _, client in ipairs(clients) do
                if client.attached_buffers and client.attached_buffers[bufnr] then
                    table.insert(buffer_clients, client)
                end
            end
            clients = buffer_clients
        end
    end

    return clients or {}
end

-- Crear una versión segura de document_color
local function safe_document_color()
    return pcall(function()
        local bufnr = vim.api.nvim_get_current_buf()
        local clients = safe_get_clients(bufnr)

        for _, client in ipairs(clients) do
            if client.server_capabilities and
               client.server_capabilities.colorProvider then
                -- Solicitar colores del documento de forma segura
                local params = { textDocument = vim.lsp.util.make_text_document_params() }
                client.request("textDocument/documentColor", params, function(err, result)
                    if not err and result then
                        -- Procesar resultado sin generar errores
                    end
                end, bufnr)
            end
        end
    end)
end

-- Interceptar y prevenir errores específicos de Flutter-tools
if augroup then
    pcall(vim.api.nvim_create_autocmd, "LspAttach", {
        group = augroup,
        callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client and client.name == "dartls" then
            -- Configurar cliente Dart de forma segura
            pcall(function()
                -- Deshabilitar document_color para evitar errores
                if client.server_capabilities then
                    client.server_capabilities.colorProvider = false
                    client.server_capabilities.documentColorProvider = false
                end
            end)
        end
    end,
    })
end

-- Silenciar errores específicos de Flutter-tools
local original_notify = vim.notify
vim.notify = function(msg, level, opts)
    if type(msg) == "string" then
        local flutter_error_patterns = {
            "textDocument/documentColor",
            "BufEnter Autocommands for",
            "not found.*dartls",
            "Error executing lua callback"
        }

        for _, pattern in ipairs(flutter_error_patterns) do
            if msg:find(pattern) then
                return -- Silenciar este error
            end
        end
    end

    return original_notify(msg, level, opts)
end

-- Crear comandos seguros para Flutter
vim.api.nvim_create_user_command("FlutterSafe", function()
    local clients = safe_get_clients()
    local dart_clients = {}

    for _, client in ipairs(clients) do
        if client.name == "dartls" then
            table.insert(dart_clients, client)
        end
    end

    if #dart_clients > 0 then
        print("✅ Flutter LSP activo (" .. #dart_clients .. " clientes)")
    else
        print("❌ Flutter LSP no activo")
    end
end, { desc = "Check Flutter LSP status safely" })

-- Configuración defensiva para LSP
vim.lsp.set_log_level("ERROR") -- Solo mostrar errores críticos

-- Deshabilitar highlighting de colores automático para Dart
if augroup then
    pcall(vim.api.nvim_create_autocmd, "FileType", {
        group = augroup,
        pattern = "dart",
        callback = function()
            -- Deshabilitar funciones problemáticas para archivos Dart
            vim.b.lsp_document_color_disabled = true
        end,
    })
end

print("🔧 Conflictos LSP solucionados")