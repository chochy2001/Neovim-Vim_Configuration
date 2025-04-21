-- Contenido para: lua/plugins/undotree.lua
return {
  {
    "mbbill/undotree",
    -- Carga perezosa: El plugin se cargará la primera vez que
    -- se ejecute el comando :UndotreeToggle (ya sea manualmente
    -- o a través del atajo de teclado).
    cmd = "UndotreeToggle",
    config = function()
      -- Tu atajo de teclado para mostrar/ocultar undotree
      vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>", {
        desc = "Toggle Undotree", -- Descripción opcional para which-key u otros
        noremap = true,
        silent = true
      })

      -- (Opcional) Puedes configurar variables globales de undotree aquí si lo necesitas
      -- Ejemplo: vim.g.undotree_WindowLayout = 2 -- Cambia la disposición de la ventana
      -- Ejemplo: vim.g.undotree_SetFocusWhenToggle = 1 -- Pone el foco en la ventana de undotree al abrirla
    end,
    -- No necesitamos la tabla 'keys' explícitamente aquí porque 'cmd' ya maneja
    -- la carga perezosa cuando se invoca el comando desde el keymap.
  }
}
