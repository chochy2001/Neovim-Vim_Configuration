
-- lua/plugins/ui.lua
return {
  -- Notificaciones mejoradas
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      vim.notify = require("notify")
      -- Puedes configurar notify aquí si quieres
    end,
  },
  -- Reemplaza vim.ui.input y vim.ui.select
  { "stevearc/dressing.nvim", event = "VeryLazy" },
  -- Iconos (usados por lualine, trouble, etc.)
  { "echasnovski/mini.icons", event = "VeryLazy" },
  -- Cursor suave (efecto visual)
  {
    "gen740/SmoothCursor.nvim",
    event = "VeryLazy",
    config = function()
      require("smoothcursor").setup()
    end,
  },
  -- Líneas de indentación visuales
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl", -- Nombre principal del módulo
    event = "VeryLazy", -- O "BufReadPre" si quieres que aparezcan inmediatamente
    opts = {}, -- Usa opts para configuración simple o config = function() para compleja
    -- config = function()
    --   require("ibl").setup() -- Puedes poner config más detallada aquí
    -- end
  },
}
