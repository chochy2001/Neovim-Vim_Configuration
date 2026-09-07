-- Prefer none-ls only when it is attached AND can format this buffer.
-- A source registered globally does not imply attachment (large files opt out).
local M = {}
function M.client(bufnr)
    local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/formatting" })
    table.sort(clients, function(a, b)
        return a.id < b.id
    end)
    local fallback
    for _, client in ipairs(clients) do
        if client.name == "null-ls" then
            local sources = require("null-ls.sources")
            local method = require("null-ls").methods.FORMATTING
            if #sources.get_available(vim.bo[bufnr].filetype, method) > 0 then
                return client
            end
        else
            fallback = fallback or client
        end
    end
    return fallback
end
function M.format(bufnr, opts)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local client = M.client(bufnr)
    if not client then
        vim.notify("No formatter attached to this buffer (:CheckFormatters)", vim.log.levels.WARN)
        return false
    end
    vim.lsp.buf.format(
        vim.tbl_extend("force", { async = true }, opts or {}, { bufnr = bufnr, id = client.id })
    )
    return true
end
return M
