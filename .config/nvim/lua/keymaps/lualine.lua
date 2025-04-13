require('lualine').setup({
  options = {
    theme = 'auto',
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
    icons_enabled = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff' },
    lualine_c = {
      {
        'filename',
        path = 1, -- muestra ruta relativa
        symbols = {
          modified = '[+]',
          readonly = '🔒',
        },
      },
      {
        'diagnostics',
        sources = { 'nvim_lsp' },
        symbols = { error = '❌', warn = '⚠️', info = 'ℹ️', hint = '💡' },
      },
    },
    lualine_x = { 'filetype', 'encoding', 'fileformat' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
})

