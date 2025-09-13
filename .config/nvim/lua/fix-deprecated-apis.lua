-- Fix para APIs deprecadas de Neovim
-- Se ejecuta automáticamente para prevenir warnings

-- Silence deprecation warnings específicos que conocemos
vim.deprecate = function(name, alternative, version, plugin)
    -- Silenciar warnings específicos conocidos
    local silent_deprecations = {
        "vim.lsp.buf_get_clients",
        "vim.lsp.get_active_clients",
        "vim.lsp.start_client",
        "vim.validate",
    }

    for _, silent in ipairs(silent_deprecations) do
        if name and name:find(silent) then
            return -- No mostrar warning
        end
    end

    -- Silenciar también si el nombre contiene estas palabras clave
    local silent_keywords = {
        "start_client",
        "validate",
        "buf_get_clients",
        "get_active_clients"
    }

    if name then
        for _, keyword in ipairs(silent_keywords) do
            if name:find(keyword) then
                return -- No mostrar warning
            end
        end
    end

    -- Para otros deprecations, mostrar solo una vez y de forma discreta
    if not vim.g.deprecation_warnings_shown then
        vim.g.deprecation_warnings_shown = {}
    end

    if not vim.g.deprecation_warnings_shown[name] then
        vim.g.deprecation_warnings_shown[name] = true
        -- Comentar esta línea para silenciar TODOS los warnings de deprecación
        -- if alternative then
        --     vim.notify(
        --         string.format("⚠️  %s is deprecated. Use %s instead.", name, alternative),
        --         vim.log.levels.WARN
        --     )
        -- end
    end
end

-- Crear aliases modernos para funciones deprecadas comunes
if vim.lsp.buf_get_clients then
    vim.lsp.get_clients = vim.lsp.get_clients or function(opts)
        if opts and opts.bufnr then
            return vim.lsp.buf_get_clients(opts.bufnr)
        else
            return vim.lsp.buf_get_clients()
        end
    end
end

-- Alias para vim.lsp.start_client -> vim.lsp.start
if vim.lsp.start_client and not vim.lsp.start then
    vim.lsp.start = vim.lsp.start_client
end

-- Crear una versión moderna de vim.validate si no existe
if not vim.validate then
    vim.validate = function(name, value, validator, optional_or_msg)
        -- Implementación simple que evita el warning
        if type(validator) == "function" then
            return validator(value)
        elseif type(validator) == "string" then
            return type(value) == validator
        end
        return true
    end
end

-- Comando para verificar clientes LSP activos sin warnings
vim.api.nvim_create_user_command("LspStatus", function()
    local clients = vim.lsp.get_clients and vim.lsp.get_clients() or vim.lsp.get_active_clients()
    if #clients > 0 then
        print("✅ LSPs activos:")
        for _, client in ipairs(clients) do
            print(string.format("  • %s (ID: %d)", client.name, client.id))
        end
    else
        print("❌ No hay LSPs activos")
        print("💡 Abre un archivo de código para activar LSPs")
    end
end, { desc = "Show active LSP clients without deprecation warnings" })

-- Mensaje de inicialización
vim.defer_fn(function()
    if vim.g.loaded_deprecated_fix ~= 1 then
        vim.g.loaded_deprecated_fix = 1
        -- print("🔧 APIs deprecadas actualizadas")
    end
end, 50)