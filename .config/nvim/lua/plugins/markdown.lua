-- lua/plugins/markdown.lua
return {
  {
    "iamcco/markdown-preview.nvim",
    -- Construir al instalar/actualizar
    build = function() vim.fn["mkdp#util#install"]() end,
    -- Cargar solo para archivos markdown
    ft = { "markdown" },
    -- Cargar también con el comando
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    config = function ()
        -- Puedes configurar variables globales si es necesario
        -- vim.g.mkdp_filetypes = { "markdown" }
    end
  },
}
