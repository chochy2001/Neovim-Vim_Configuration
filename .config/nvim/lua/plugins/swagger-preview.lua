return {
    "vinnymeller/swagger-preview.nvim",
    build = vim.fn.executable("npm") == 1 and "npm install -g swagger-ui-watcher" or nil,
    -- Lazy-load on its own commands instead of every startup: the plugin
    -- only makes sense for Swagger/OpenAPI documents.
    cmd = { "SwaggerPreview", "SwaggerPreviewStop", "SwaggerPreviewToggle" },
    config = true,
}
