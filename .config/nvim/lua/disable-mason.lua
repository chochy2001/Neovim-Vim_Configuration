-- Deshabilitación completa de Mason para evitar errores
-- Ejecuta automáticamente al cargar Neovim

-- Prevenir la carga de comandos Mason
vim.g.loaded_mason = 1
vim.g.mason_disabled = true

-- Crear comandos dummy para evitar errores si algo trata de ejecutarlos
local mason_commands = {
    "Mason",
    "MasonInstall",
    "MasonUninstall",
    "MasonUpdate",
    "MasonLog",
}

for _, cmd in ipairs(mason_commands) do
    vim.api.nvim_create_user_command(cmd, function()
        vim.notify("Mason está deshabilitado. Usa LSPs del sistema.", vim.log.levels.WARN)
    end, { desc = "Mason disabled - use system LSPs" })
end

-- Mensaje informativo
if vim.fn.has('vim_starting') == 1 then
    vim.defer_fn(function()
        print("ℹ️  Mason deshabilitado - usando LSPs del sistema")
    end, 100)
end