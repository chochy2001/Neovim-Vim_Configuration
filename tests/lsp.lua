local server_errors = {}
local log_message = vim.lsp.handlers["window/logMessage"]
vim.lsp.handlers["window/logMessage"] = function(err, result, ctx, config)
    if result and result.type == vim.lsp.protocol.MessageType.Error then
        table.insert(server_errors, result.message)
    end
    return log_message(err, result, ctx, config)
end
vim.schedule(function()
    local path, expected = vim.env.NVIM_TEST_FILE, vim.env.NVIM_TEST_LSP
    local ok, err = pcall(function()
        vim.cmd.edit(vim.fn.fnameescape(path))
        local bufnr = vim.api.nvim_get_current_buf()
        assert(
            vim.wait(25000, function()
                for _, c in ipairs(vim.lsp.get_clients({ bufnr = bufnr, name = expected })) do
                    if c.initialized then
                        return true
                    end
                end
                return false
            end),
            expected .. " did not attach to " .. path
        )
        -- Let the initial didOpen/LspAttach notifications complete before a request.
        vim.wait(200, function()
            return false
        end)
        local clients = vim.lsp.get_clients({ bufnr = bufnr, name = expected })
        assert(#clients == 1, "duplicate clients: " .. expected)
        assert(vim.fn.maparg("<leader>fm", "n", false, true).buffer == 1, "format key missing")
        local c = clients[1]
        assert(c:supports_method("textDocument/documentSymbol"), "server does not support the tested request")
        do
            local reply, request_error = c:request_sync(
                "textDocument/documentSymbol",
                { textDocument = { uri = vim.uri_from_bufnr(bufnr) } },
                60000,
                bufnr
            )
            assert(reply and not reply.err, vim.inspect(reply or request_error))
        end
        vim.wait(500, function()
            return false
        end)
        assert(#server_errors == 0, table.concat(server_errors, "\n"))
        print("PASS LSP " .. expected .. ": attached, unique, request answered")
    end)
    if not ok then
        print("FAIL LSP " .. expected .. ": " .. tostring(err))
    end
    print("RESULT lsp: " .. (ok and "0" or "1") .. " failures")
    vim.cmd(ok and "qa!" or "cquit 1")
end)
