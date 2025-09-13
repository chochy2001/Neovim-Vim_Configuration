-- Solución definitiva para silenciar TODOS los warnings de deprecación
-- Intercepta y silencia automáticamente

-- Guardar la función vim.deprecate original
local original_deprecate = vim.deprecate

-- Reemplazar vim.deprecate para silenciar SOLO deprecaciones específicas
vim.deprecate = function(name, alternative, version, plugin, stacklevel)
    -- Silenciar SOLO deprecaciones específicas conocidas
    local deprecation_patterns = {
        "is deprecated",
        "deprecated.*Use.*instead",
        "start_client.*deprecated",
        "buf_get_clients.*deprecated",
        "nvim_buf_get_clients.*deprecated",
        "vim%.lsp%.diagnostic"
    }

    if type(name) == "string" then
        for _, pattern in ipairs(deprecation_patterns) do
            if name:find(pattern) then
                return -- Silenciar solo deprecaciones conocidas
            end
        end
    end

    -- Para otros casos, llamar a la función original
    return original_deprecate(name, alternative, version, plugin, stacklevel)
end

-- Interceptar vim.notify SOLO para deprecaciones específicas
local original_notify = vim.notify

vim.notify = function(msg, level, opts)
    -- Silenciar SOLO mensajes de deprecación específicos
    if type(msg) == "string" then
        local deprecation_patterns = {
            -- Solo deprecaciones reales
            "is deprecated",
            "deprecated.*Use.*instead",
            "start_client.*deprecated",
            "buf_get_clients.*deprecated"
        }

        for _, pattern in ipairs(deprecation_patterns) do
            if msg:find(pattern) then
                return -- Silenciar solo deprecaciones
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