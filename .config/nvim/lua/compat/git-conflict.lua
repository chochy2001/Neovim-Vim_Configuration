-- git-conflict 2.1 still calls the removed table/alias vim.validate API.
-- Load only its two affected modules with a local API adapter. Never replace
-- vim.validate or vim.highlight globally: unrelated plugins keep native checks.
local M = {}
function M.load()
    local api = setmetatable({ highlight = vim.hl }, { __index = vim })
    local aliases = { b = "boolean", c = "callable", f = "function", n = "number", s = "string", t = "table" }
    api.validate = function(name, ...)
        if type(name) ~= "table" then
            return vim.validate(name, ...)
        end
        for key, spec in pairs(name) do
            vim.validate(key, spec[1], aliases[spec[2]] or spec[2], spec[3])
        end
    end
    for _, name in ipairs({ "git-conflict.colors", "git-conflict" }) do
        if not package.loaded[name] then
            local path = vim.api.nvim_get_runtime_file("lua/" .. name:gsub("%.", "/") .. ".lua", false)[1]
            assert(path, "git-conflict module not found: " .. name)
            local chunk = assert(loadfile(path))
            setfenv(chunk, setmetatable({ vim = api }, { __index = _G }))
            package.loaded[name] = chunk()
        end
    end
    return package.loaded["git-conflict"]
end
return M
