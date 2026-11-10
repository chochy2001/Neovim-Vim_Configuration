-- Pure configuration regressions: nvim --clean -l tests/regression.lua
local root = vim.fn.getcwd()
vim.opt.rtp:prepend(root .. "/.config/nvim")
local failed, passed = 0, 0
local function test(name, fn)
    local ok, err = pcall(fn)
    if ok then
        passed = passed + 1
        print("PASS " .. name)
    else
        failed = failed + 1
        print("FAIL " .. name .. ": " .. tostring(err))
    end
end
local function eq(expected, actual)
    assert(
        vim.deep_equal(expected, actual),
        "expected " .. vim.inspect(expected) .. ", got " .. vim.inspect(actual)
    )
end
test("AI copies only the selected characters", function()
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { "before SELECT after" })
    vim.api.nvim_win_set_cursor(0, { 1, 7 })
    vim.cmd.normal({ args = { "v5l" }, bang = true })
    vim.cmd.normal({ args = { vim.keycode("<Esc>") }, bang = true })
    eq("SELECT", require("ai-terminals").get_visual_text())
end)
test("Dart restart delegates to flutter-tools without stopping other projects", function()
    local stopped, restarted = 0, 0
    local get_clients = vim.lsp.get_clients
    local old = package.loaded["flutter-tools.lsp"]
    vim.lsp.get_clients = function()
        return {
            {
                stop = function()
                    stopped = stopped + 1
                end,
            },
        }
    end
    package.loaded["flutter-tools.lsp"] = {
        restart = function()
            restarted = restarted + 1
        end,
    }
    vim.bo.filetype = "dart"
    require("lsp-utils").restart_dart_lsp()
    vim.lsp.get_clients = get_clients
    package.loaded["flutter-tools.lsp"] = old
    eq(0, stopped)
    eq(1, restarted)
end)
test("buffer close refuses to discard unsaved changes", function()
    local specs = dofile(root .. "/.config/nvim/lua/plugins/session-workspace.lua")
    local setup = package.loaded.bufferline
    local options
    package.loaded.bufferline = {
        setup = function(opts)
            options = opts.options
        end,
    }
    for _, spec in ipairs(specs) do
        if spec[1] == "akinsho/bufferline.nvim" then
            spec.config()
        end
    end
    package.loaded.bufferline = setup
    eq("bdelete %d", options.close_command)
    eq("bdelete %d", options.right_mouse_command)
end)
test("completion buffer source has its plugin dependency", function()
    local spec = dofile(root .. "/.config/nvim/lua/plugins/completions.lua")[1]
    assert(vim.tbl_contains(spec.dependencies, "hrsh7th/cmp-buffer"), "cmp-buffer is missing")
end)
test("plugin key declarations have no conflicting owners", function()
    local seen = {}
    local function visit(spec)
        if type(spec) ~= "table" then
            return
        end
        if type(spec[1]) == "string" then
            for _, key in ipairs(type(spec.keys) == "table" and spec.keys or {}) do
                if type(key) == "table" then
                    local modes = type(key.mode) == "table" and key.mode or { key.mode or "n" }
                    for _, mode in ipairs(modes) do
                        local id = mode .. ":" .. key[1]:gsub("<leader>", " "):gsub("<Leader>", " ")
                        assert(
                            not seen[id] or seen[id] == spec[1],
                            id .. " owned by " .. tostring(seen[id]) .. " and " .. spec[1]
                        )
                        seen[id] = spec[1]
                    end
                end
            end
        else
            for _, child in ipairs(spec) do
                visit(child)
            end
        end
    end
    for _, file in ipairs(vim.fn.glob(".config/nvim/lua/plugins/*.lua", false, true)) do
        visit(dofile(file))
    end
end)
test("a key with an action in lazy keys is not mapped again in config", function()
    -- A `keys` entry with a right-hand side already owns the mapping. Setting
    -- the same lhs again inside config() is a duplicate that can drift.
    -- Stubs (`{ lhs, desc = ... }`) are fine: config() provides their action.
    local function collect(spec, owned)
        if type(spec) ~= "table" then
            return
        end
        if type(spec[1]) == "string" then
            for _, key in ipairs(type(spec.keys) == "table" and spec.keys or {}) do
                if type(key) == "table" and key[2] ~= nil then
                    local modes = type(key.mode) == "table" and key.mode or { key.mode or "n" }
                    for _, mode in ipairs(modes) do
                        owned[mode .. " " .. key[1]] = true
                    end
                end
            end
        else
            for _, child in ipairs(spec) do
                collect(child, owned)
            end
        end
    end
    local dupes = {}
    for _, file in ipairs(vim.fn.glob(".config/nvim/lua/plugins/*.lua", false, true)) do
        local owned = {}
        collect(dofile(file), owned)
        local text = table.concat(vim.fn.readfile(file), "\n")
        for mode, lhs in text:gmatch('vim%.keymap%.set%(%s*"(%a)",%s*"([^"]+)"') do
            if owned[mode .. " " .. lhs] then
                table.insert(dupes, vim.fn.fnamemodify(file, ":t") .. " " .. mode .. " " .. lhs)
            end
        end
    end
    assert(#dupes == 0, "duplicated mappings: " .. table.concat(dupes, ", "))
end)
test("every AI key opens a registered assistant and each CLI has a key", function()
    local names = require("ai-terminals").names()
    for _, cli in ipairs({ "agy", "claude", "codex", "cursor-agent", "kimi", "muse", "opencode" }) do
        assert(require("ai-terminals").has_command(cli), cli .. " is not registered")
    end
    local spec = dofile(root .. "/.config/nvim/lua/plugins/ai-terminal.lua")[1]
    local opened, called = {}, nil
    package.loaded["ai-terminals"].toggle = function(name)
        called = name
    end
    for _, key in ipairs(spec.keys) do
        if (key.mode or "n") == "n" then
            called = nil
            key[2]()
            assert(vim.tbl_contains(names, called), key[1] .. " opens unknown " .. tostring(called))
            opened[called] = true
        end
    end
    package.loaded["ai-terminals"] = nil
    for _, name in ipairs(names) do
        assert(opened[name], "no key opens " .. name)
    end
end)
test("buffers changed on disk by an agent are reloaded", function()
    require("vim-options")
    for _, event in ipairs({ "FocusGained", "TermLeave", "BufEnter" }) do
        local found = vim.api.nvim_get_autocmds({ group = "external_changes", event = event })
        assert(#found == 1, event .. " does not run checktime")
    end
    -- :checktime inside an autocmd is postponed to the main loop, which a
    -- `-l` script never reaches: drive a real headless Neovim instead.
    local path, out = vim.fn.tempname(), vim.fn.tempname()
    vim.fn.writefile({ "old" }, path)
    local script = string.format(
        [[
vim.opt.rtp:prepend(%q)
require("vim-options")
vim.cmd.edit(%q)
vim.uv.sleep(1100)
vim.fn.writefile({ "new" }, %q)
vim.api.nvim_exec_autocmds("FocusGained", {})
vim.defer_fn(function()
    vim.fn.writefile(vim.api.nvim_buf_get_lines(0, 0, -1, false), %q)
    vim.cmd("qa!")
end, 300)
]],
        root .. "/.config/nvim",
        path,
        path,
        out
    )
    local result =
        vim.system({ vim.v.progpath, "--clean", "--headless", "-n", "-i", "NONE", "-c", "lua " .. script })
            :wait(15000)
    eq(0, result.code)
    eq({ "new" }, vim.fn.readfile(out))
    vim.fn.delete(path)
    vim.fn.delete(out)
end)
test("syntax of every config Lua file", function()
    for _, file in ipairs(vim.fn.glob(root .. "/.config/nvim/**/*.lua", false, true)) do
        assert(loadfile(file))
    end
end)
test("formatting falls back when none-ls is not attached", function()
    local get = vim.lsp.get_clients
    local old = package.loaded["null-ls.sources"]
    package.loaded["null-ls.sources"] = {
        get_available = function()
            return { { name = "black" } }
        end,
    }
    vim.lsp.get_clients = function()
        return { { id = 42, name = "gopls" } }
    end
    local client = require("formatting").client(vim.api.nvim_get_current_buf())
    vim.lsp.get_clients = get
    package.loaded["null-ls.sources"] = old
    eq(42, client.id)
end)
test("AI handles line, block and UTF-8 selections", function()
    local function select(lines, pos, keys)
        vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
        vim.api.nvim_win_set_cursor(0, pos)
        vim.cmd.normal({ args = { vim.keycode(keys .. "<Esc>") }, bang = true })
        return require("ai-terminals").get_visual_text()
    end
    eq("áé", select({ "aáéb" }, { 1, 1 }, "vl"))
    eq("ab\ncd", select({ "ab", "cd", "ef" }, { 1, 0 }, "Vj"))
    eq("bc\nfg", select({ "abcd", "efgh" }, { 1, 1 }, "<C-v>jl"))
end)
test("standalone JavaScript runs with spaces, apostrophes and dollar signs in its path", function()
    require("vim-options")
    local dir = vim.fn.tempname() .. " space's $value"
    vim.fn.mkdir(dir, "p")
    local path = dir .. "/hello.js"
    vim.fn.writefile({ "console.log('runner-ok')" }, path)
    local cmd = assert(require("runner").command("javascript", path), "Node unavailable")
    local output = vim.fn.system(cmd)
    eq(0, vim.v.shell_error)
    assert(output:find("runner%-ok"), output)
    vim.fn.delete(path)
    vim.fn.delete(dir, "d")
end)
print(string.format("RESULT %d passed, %d failed", passed, failed))
vim.cmd(failed == 0 and "qa!" or "cquit 1")
