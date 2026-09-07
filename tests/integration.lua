local failures = {}
local function test(name, fn)
    local ok, err = pcall(fn)
    if ok then
        print("PASS " .. name)
    else
        table.insert(failures, name .. ": " .. tostring(err))
        print("FAIL " .. failures[#failures])
    end
end
local errors = {}
local notify = vim.notify
vim.notify = function(msg, level, opts)
    if level == vim.log.levels.ERROR then
        table.insert(errors, tostring(msg))
    end
    notify(msg, level, opts)
end
local config = require("lazy.core.config")
local native_validate = vim.validate
test("all configured plugins load", function()
    local names = vim.tbl_keys(config.plugins)
    table.sort(names)
    require("lazy").load({ plugins = names })
    vim.wait(500)
    for _, name in ipairs(names) do
        local p = config.plugins[name]
        assert(p._.loaded, name .. " failed to load")
    end
end)
test("compatibility adapter preserves Neovim APIs", function()
    assert(vim.validate == native_validate, "vim.validate was replaced globally")
    local colors = require("git-conflict.colors")
    assert(colors.shade_color(0x808080, -50) == "#404040")
end)
test("Overseer templates resolve", function()
    local completed = false
    require("overseer.template").list({ dir = vim.fn.getcwd() }, function(templates, report)
        assert(type(templates) == "table", vim.inspect(report))
        completed = true
    end)
    assert(
        vim.wait(10000, function()
            return completed
        end),
        "template discovery timed out"
    )
end)
test("completion sources are registered", function()
    vim.api.nvim_exec_autocmds("InsertEnter", {})
    local cmp = require("cmp")
    local found = {}
    for _, source in pairs(cmp.core.sources) do
        found[source.name] = true
    end
    for _, name in ipairs({ "buffer", "luasnip" }) do
        assert(found[name], name)
    end
    -- cmp-nvim-lsp registers a source only for an attached LSP client.
    assert(type(require("cmp_nvim_lsp")._on_insert_enter) == "function")
end)
test("Mason only enables explicitly configured servers", function()
    assert(require("mason-lspconfig.settings").current.automatic_enable == false)
    assert(not vim.lsp.is_enabled("dartls"), "Dart must remain owned by flutter-tools")
end)
test("RunFile preserves literal template words in paths", function()
    local dir = vim.fn.tempname() .. " space's $file $dir"
    vim.fn.mkdir(dir, "p")
    local path = dir .. "/test.js"
    vim.fn.writefile({ "console.log('runner-dispatch-ok')" }, path)
    vim.cmd.edit(vim.fn.fnameescape(path))
    local utils = require("code_runner.utils")
    local dispatch, rendered = utils.runMode, nil
    utils.runMode = function(_, command)
        rendered = command
    end
    local ok, err = pcall(vim.cmd.RunFile)
    utils.runMode = dispatch
    assert(ok, err)
    assert(rendered, "RunFile did not dispatch a command")
    local output = vim.fn.system(rendered)
    assert(vim.v.shell_error == 0 and output:find("runner%-dispatch%-ok"), output)
    vim.cmd.bwipeout()
    vim.fn.delete(path)
    vim.fn.delete(dir, "d")
end)

test("no configuration errors were notified", function()
    assert(#errors == 0, table.concat(errors, "\n"))
end)
print(string.format("RESULT integration: %d failures", #failures))
vim.cmd(#failures == 0 and "qa!" or "cquit 1")
