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
    for _, cli in ipairs({
        "agy",
        "claude",
        "codex",
        "copilot",
        "cursor-agent",
        "gemini",
        "grok",
        "kimi",
        "muse",
        "opencode",
    }) do
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
test("agent edits reload idle buffers and never clobber unsaved edits", function()
    -- Neovim keeps focus while an agent in another herdr pane edits the file:
    -- no focus event fires, so only the file watcher can notice.
    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir, "p")
    local idle, renamed, dirty, untouched =
        dir .. "/idle.txt", dir .. "/renamed.txt", dir .. "/dirty.txt", dir .. "/untouched.txt"
    for _, f in ipairs({ idle, renamed, dirty, untouched }) do
        vim.fn.writefile({ "old" }, f)
    end
    local out = dir .. "/out.json"
    local script = string.format(
        [[
vim.opt.rtp:prepend(%q)
require("vim-options")
local warnings = {}
local notify = vim.notify
vim.notify = function(msg, level, opts)
    if level == vim.log.levels.WARN then table.insert(warnings, msg) end
    return notify(msg, level, opts)
end
local function open(f) vim.cmd.edit(f) return vim.api.nvim_get_current_buf() end
local b = { idle = open(%q), renamed = open(%q), dirty = open(%q), untouched = open(%q) }
vim.api.nvim_buf_set_lines(b.dirty, 0, -1, false, { "mine" })
vim.api.nvim_buf_set_lines(b.untouched, 0, -1, false, { "mine too" })
local watching = require("external-changes").count()
local function text(k) return vim.api.nvim_buf_get_lines(b[k], 0, -1, false)[1] end
-- Wait for each effect instead of fixed sleeps: file events are slower under load.
vim.uv.sleep(1100) -- let the mtime move past the time the buffers were read
vim.fn.writefile({ "new" }, %q)
vim.fn.writefile({ "new" }, %q .. ".tmp")
vim.uv.fs_rename(%q .. ".tmp", %q)
vim.fn.writefile({ "agent" }, %q)
vim.wait(10000, function() return text("idle") == "new" and text("renamed") == "new" and #warnings > 0 end, 50)
vim.uv.sleep(1100)
-- Second rename proves the watcher re-armed after the first one.
vim.fn.writefile({ "newer" }, %q .. ".tmp")
vim.uv.fs_rename(%q .. ".tmp", %q)
vim.wait(10000, function() return text("renamed") == "newer" end, 50)
vim.api.nvim_exec_autocmds("CursorHold", { buffer = b.untouched })
vim.wait(300)
local final = {}
for k in pairs(b) do final[k] = text(k) end
vim.fn.writefile({ vim.json.encode({ text = final, warnings = warnings, watching = watching }) }, %q)
vim.cmd("qa!")
]],
        root .. "/.config/nvim",
        idle,
        renamed,
        dirty,
        untouched,
        idle,
        renamed,
        renamed,
        renamed,
        dirty,
        renamed,
        renamed,
        renamed,
        out
    )
    local result =
        vim.system({ vim.v.progpath, "--clean", "--headless", "-n", "-i", "NONE", "-c", "lua " .. script })
            :wait(20000)
    eq(0, result.code)
    local got = vim.json.decode(vim.fn.readfile(out)[1])
    eq(4, got.watching)
    eq({ idle = "new", renamed = "newer", dirty = "mine", untouched = "mine too" }, got.text)
    eq(1, #got.warnings)
    assert(got.warnings[1]:find("dirty.txt", 1, true), got.warnings[1])
    vim.fn.delete(dir, "rf")
end)
test("icons are real glyphs, with an ASCII fallback", function()
    -- Icons once got stripped to blank strings and every sign went invisible.
    local function load(env)
        local code = "vim.env.NVIM_NERD_FONT = "
            .. vim.inspect(env)
            .. " package.loaded.icons = nil"
            .. " local i = require('icons')"
            .. " local out = {}"
            .. " for _, v in pairs(i.diagnostic_signs()) do table.insert(out, v) end"
            .. " for _, k in ipairs({ 'git_branch', 'readonly', 'lsp', 'folder_closed', 'fold_open' }) do"
            .. " table.insert(out, i[k]) end"
            .. " return out"
        return assert(loadstring(code))()
    end
    for _, text in ipairs(load(nil)) do
        local code = vim.fn.char2nr(text)
        assert(code >= 0xE000 and code <= 0xF8FF, vim.inspect(text) .. " is not a Nerd Font glyph")
    end
    for _, text in ipairs(load("0")) do
        assert(text:match("^[%w%+%-<>]+ ?$"), vim.inspect(text) .. " is not ASCII")
    end
    vim.env.NVIM_NERD_FONT = nil
    package.loaded.icons = nil
end)
test("dashboard header is solid, aligned and every entry has an icon and its documented key", function()
    local spec = dofile(root .. "/.config/nvim/lua/plugins/dashboard.lua")[1]
    local old = package.loaded.dashboard
    local opts
    package.loaded.dashboard = {
        setup = function(o)
            opts = o
        end,
    }
    spec.config()
    package.loaded.dashboard = old
    local art = vim.tbl_filter(function(line)
        return line:find("█", 1, true) ~= nil
    end, opts.config.header)
    assert(#art == 5, "expected 5 logo rows, got " .. #art)
    for _, line in ipairs(art) do
        -- Box-drawing shadows render with gaps when the line height is not exact.
        for _, box in ipairs({ "╗", "╔", "║", "═", "╝", "╚" }) do
            assert(not line:find(box, 1, true), "logo uses box-drawing shadow: " .. line)
        end
        eq(vim.fn.strdisplaywidth(art[1]), vim.fn.strdisplaywidth(line))
    end
    local keys = {}
    for _, item in ipairs(opts.config.center) do
        local code = vim.fn.char2nr(item.icon)
        assert(code >= 0xE000 and code <= 0xF8FF, item.desc .. " has no Nerd Font icon")
        table.insert(keys, item.key)
    end
    eq({ "f", "g", "r", "e", "a", "m", "l", "q" }, keys)
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
