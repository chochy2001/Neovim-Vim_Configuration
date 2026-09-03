return {
    "vinnymeller/swagger-preview.nvim",
    build = "npm install -g swagger-ui-watcher",
    -- Lazy-load on its own commands instead of every startup: the plugin
    -- only makes sense for Swagger/OpenAPI documents.
    cmd = { "SwaggerPreview", "SwaggerPreviewStop", "SwaggerPreviewToggle" },
    config = true,
}
