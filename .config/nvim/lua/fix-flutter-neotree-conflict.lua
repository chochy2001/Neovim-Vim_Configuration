-- Fix for Flutter/Dart duplicate LSP clients and neo-tree buffer conflicts

-- Clean up duplicate dartls clients when opening Dart files
local function cleanup_duplicate_lsp_clients()
    local clients = vim.lsp.get_clients({ name = "dartls" })
    if #clients > 1 then
        for i = 2, #clients do
            clients[i]:stop(true)
        end
    end
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "dart",
    callback = function()
        vim.defer_fn(cleanup_duplicate_lsp_clients, 100)
    end,
})
