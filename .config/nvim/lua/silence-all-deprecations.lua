-- Solución definitiva para silenciar TODOS los warnings de deprecación
-- Intercepta y silencia automáticamente

-- Guardar la función vim.deprecate original
local original_deprecate = vim.deprecate

-- Reemplazar vim.deprecate para silenciar SOLO deprecaciones específicas conocidas y seguras
vim.deprecate = function(name, alternative, version, plugin, stacklevel)
    -- Lista de deprecaciones específicas conocidas y seguras para silenciar
    local known_safe_deprecations = {
        -- Coincidencias exactas o muy específicas
        ["vim.lsp.buf.formatting"] = true,
        ["vim.lsp.buf.formatting_sync"] = true,
        ["vim.lsp.diagnostic.get_all"] = true,
        ["vim.lsp.diagnostic.get_next"] = true,
        ["vim.lsp.diagnostic.get_prev"] = true,
        ["vim.lsp.diagnostic.goto_next"] = true,
        ["vim.lsp.diagnostic.goto_prev"] = true,
        ["vim.lsp.util.get_progress_messages"] = true,
        ["vim.lsp.buf_get_clients"] = true,
        ["vim.lsp.get_active_clients"] = true,
    }

    if type(name) == "string" and known_safe_deprecations[name] then
        -- Opcional: log de deprecaciones filtradas para revisión futura
        local log_file = vim.fn.stdpath("cache") .. "/filtered_deprecations.log"
        local f = io.open(log_file, "a")
        if f then
            f:write(os.date("[%Y-%m-%d %H:%M:%S] ") .. name .. " -> " .. (alternative or "N/A") .. "\n")
            f:close()
        end
        return -- Silenciar solo deprecaciones conocidas y seguras
    end

    -- Para otros casos, llamar a la función original (mostrar deprecación)
    return original_deprecate(name, alternative, version, plugin, stacklevel)
end

-- Interceptar vim.notify SOLO para deprecaciones específicas
local original_notify = vim.notify

vim.notify = function(msg, level, opts)
    -- Silenciar SOLO mensajes de deprecación específicos conocidos
    if type(msg) == "string" then
        -- Lista de mensajes exactos o patrones muy específicos a silenciar
        local known_safe_notifications = {
            "'vim.lsp.diagnostic' is deprecated. Use 'vim.diagnostic' instead.",
            "'start_client' is deprecated",
            "'buf_get_clients' is deprecated",
            "'nvim_buf_get_clients' is deprecated",
        }

        -- Verificar coincidencias exactas primero
        for _, known_msg in ipairs(known_safe_notifications) do
            if msg == known_msg or msg:find(known_msg, 1, true) then
                return -- Silenciar solo deprecaciones conocidas
            end
        end
    end

    -- Para TODOS los demás mensajes, usar la función original
    return original_notify(msg, level, opts)
end

-- Configurar opciones para reducir verbosidad
vim.opt.shortmess:append("c") -- No mostrar mensajes de completado
vim.opt.report = 9999 -- No reportar cambios pequeños

-- Deshabilitar warnings específicos de LSP
vim.g.loaded_lsp_warnings = 1

-- Crear versión silenciosa de checkhealth
vim.api.nvim_create_user_command("CheckhealthQuiet", function()
    -- Capturar la salida de checkhealth y filtrar warnings de deprecación
    local output = vim.fn.execute("checkhealth")
    local lines = vim.split(output, "\n")
    local filtered_lines = {}

    for _, line in ipairs(lines) do
        if not (line:find("deprecated") or line:find("start_client") or line:find("buf_get_clients")) then
            table.insert(filtered_lines, line)
        end
    end

    print(table.concat(filtered_lines, "\n"))
end, { desc = "Run checkhealth without deprecation warnings" })

-- Mensaje de confirmación
vim.defer_fn(function()
    -- print("🔇 Todos los warnings de deprecación silenciados")
end, 100)