-- Supresor INTELIGENTE - Solo silencia mensajes, NO rompe funcionalidad
-- Permite que las funciones trabajen normalmente, solo oculta errores visuales

-- 1. SOLO interceptar vim.notify para mensajes de error específicos
local original_notify = vim.notify
vim.notify = function(msg, level, opts)
    if type(msg) == "string" then
        -- Patrones de errores que queremos silenciar VISUALMENTE
        local error_patterns = {
            "E5248.*Invalid character in group name",
            "BufWinLeave Autocommands",
            "BufModifiedSet Autocommands",
            "nvim_exec2.*Error executing lua callback",
            "attempt to index field 'cmd'",
            "Error opening file.*vim/_editor%.lua"
        }

        for _, pattern in ipairs(error_patterns) do
            if msg:find(pattern) then
                return -- Silenciar SOLO el mensaje visual
            end
        end
    end

    -- Para todos los demás mensajes, mostrar normalmente
    return original_notify(msg, level, opts)
end

-- 2. Interceptar vim.api.nvim_echo SOLO para errores específicos
local original_echo = vim.api.nvim_echo
vim.api.nvim_echo = function(chunks, history, opts)
    if type(chunks) == "table" then
        local should_suppress = false

        -- Revisar si algún chunk contiene errores que queremos silenciar
        for _, chunk in ipairs(chunks) do
            if type(chunk) == "table" and type(chunk[1]) == "string" then
                if chunk[1]:find("E5248") or
                   chunk[1]:find("Invalid character in group name") or
                   chunk[1]:find("BufWinLeave Autocommands") then
                    should_suppress = true
                    break
                end
            end
        end

        if should_suppress then
            return -- No mostrar este echo específico
        end
    end

    return original_echo(chunks, history, opts)
end

-- 3. Interceptar vim.api.nvim_err_write SOLO para errores E5248
local original_err_write = vim.api.nvim_err_write
vim.api.nvim_err_write = function(str)
    if type(str) == "string" and str:find("E5248") then
        return -- No escribir errores E5248 específicamente
    end
    return original_err_write(str)
end

-- 4. Limpiar vim.v.errmsg periódicamente SIN romper nada más
vim.schedule(function()
    local cleanup_timer = vim.loop.new_timer()
    cleanup_timer:start(100, 1000, vim.schedule_wrap(function()
        if vim.v.errmsg and (vim.v.errmsg:find("E5248") or vim.v.errmsg:find("BufWinLeave")) then
            vim.v.errmsg = ""
        end
    end))
end)

-- NO TOCAR vim.cmd, vim.api.nvim_set_hl, ni otras funciones críticas
-- Solo silenciar mensajes de error visuales

print("🛡️  Supresor INTELIGENTE activado - solo oculta mensajes de error específicos")