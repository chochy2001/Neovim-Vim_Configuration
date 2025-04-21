return {
  {
    "akinsho/toggleterm.nvim",
    version = "*", -- Puedes especificar una versión o tag si lo prefieres
    -- Carga perezosa: Se carga cuando se ejecuta el comando :ToggleTerm
    -- o cuando se usa uno de los atajos definidos en 'keys'.
    cmd = "ToggleTerm",
    keys = {
      -- Atajos que activarán la carga del plugin si aún no está cargado
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "ToggleTerm (Horizontal)" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", desc = "ToggleTerm (Vertical)" },
      { "<leader>tt", "<cmd>ToggleTerm direction=tab<CR>", desc = "ToggleTerm (Tab)" },
    },
    config = function()
      -- Aquí va toda tu configuración de setup original
      require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return vim.o.lines * 0.6
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.6
          end
        end,
        -- open_mapping = [[<leader>t]], -- Comentado, ya manejado por 'keys' de lazy.nvim
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true, -- Mantenlo si quieres los mapeos por defecto en modo inserción
        terminal_mappings = true, -- Mantenlo si quieres los mapeos por defecto en modo terminal
        persist_size = true,
        direction = "float", -- default
        float_opts = {
          border = "curved",
          winblend = 3,
        },
      })

      -- Atajos / Mapeos adicionales que se deben definir DESPUÉS del setup.
      -- El mapeo para <Esc> en modo terminal es un buen ejemplo.
      local opts_silent = { silent = true } -- noremap=true es el valor por defecto para vim.keymap.set

      -- Esc para salir de modo terminal (t)
      vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", opts_silent)

      -- Si NO hubieras usado la tabla 'keys' de lazy.nvim para los atajos principales,
      -- los definirías aquí también:
      -- vim.keymap.set("n", "<leader>t", "<cmd>ToggleTerm<CR>", opts_silent)
      -- vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", opts_silent)
      -- vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", opts_silent)
      -- vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm direction=tab<CR>", opts_silent)
    end,
  },
}
