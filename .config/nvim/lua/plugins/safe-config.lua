-- Configuración temporal segura para evitar errores
-- Este archivo se puede remover una vez que todo funcione

return {
    -- Asegurar que nui.nvim se cargue correctamente
    {
        "MunifTanjim/nui.nvim",
        lazy = false,
        priority = 100,
    },

    -- Configuración más conservadora de algunos plugins problemáticos
    {
        "nvim-neo-tree/neo-tree.nvim",
        enabled = true, -- Puedes cambiar a false si sigue dando problemas
    },
}