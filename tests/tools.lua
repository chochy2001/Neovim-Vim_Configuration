-- Optional installed-tool checks: python scripts/verify.py --tools
vim.schedule(function()
    require("lazy").load({ plugins = { "mason.nvim" } })
    local previous_dir = vim.fn.getcwd()
    local fixture_dir = vim.fn.tempname()
    vim.fn.mkdir(fixture_dir, "p")
    -- Format a separate scratch project; this repo intentionally ignores tmp/.
    -- Prettier respects .gitignore, including for --stdin-filepath.
    vim.cmd.cd(vim.fn.fnameescape(fixture_dir))
    local failures = 0
    local function test(name, fn)
        local ok, err = pcall(fn)
        print((ok and "PASS " or "FAIL ") .. name .. (ok and "" or ": " .. tostring(err)))
        failures = failures + (ok and 0 or 1)
    end
    test("installed parsers load and compile their queries", function()
        -- Windows updates can leave a loaded DLL renamed to *.so<timestamp>.
        -- Only *.so files are actual parser libraries.
        local parsers = {}
        local parser_dir = require("nvim-treesitter.config").get_install_dir("parser")
        for file in vim.fs.dir(parser_dir) do
            local lang = file:match("^(.-)%.so$")
            if lang then
                table.insert(parsers, lang)
            end
        end
        assert(#parsers > 0, "No parsers installed")
        for _, lang in ipairs(parsers) do
            assert(vim.treesitter.language.add(lang), lang .. " parser did not load")
            local parser = vim.treesitter.get_string_parser("", lang)
            assert(parser:parse()[1], lang .. " did not produce a tree")
            for _, kind in ipairs({ "highlights", "folds", "indents", "injections", "locals", "textobjects" }) do
                -- Missing optional queries are fine; malformed existing queries raise an error.
                vim.treesitter.query.get(lang, kind)
            end
        end
        print("Validated " .. #parsers .. " installed parsers")
    end)
    for _, fixture in ipairs({
        { ft = "lua", input = "local x={a=1,b=2}", expected = "local x = { a = 1, b = 2 }", tool = "stylua" },
        { ft = "json", input = '{"a":1,"b":2}', expected = '{ "a": 1, "b": 2 }', tool = "prettier" },
    }) do
        test("real " .. fixture.ft .. " formatting via attached none-ls", function()
            assert(vim.fn.executable(fixture.tool) == 1, fixture.tool .. " must be installed")
            local path = fixture_dir .. "/sample." .. fixture.ft
            vim.fn.writefile({ fixture.input }, path)
            vim.cmd.edit(vim.fn.fnameescape(path))
            local buf = vim.api.nvim_get_current_buf()
            assert(
                vim.wait(10000, function()
                    local client = require("formatting").client(buf)
                    return client and client.name == "null-ls" and client.initialized
                end),
                "none-ls did not attach"
            )
            local client = assert(require("formatting").client(buf))
            -- on_attach precedes didOpen; allow none-ls to receive the buffer contents.
            vim.wait(200, function()
                return false
            end)
            vim.lsp.buf.format({ bufnr = buf, id = client.id, timeout_ms = 10000 })
            local actual = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")
            assert(actual == fixture.expected, "unexpected output: " .. actual)
            vim.cmd("bwipeout!")
            vim.fn.delete(path)
        end)
    end
    vim.cmd.cd(vim.fn.fnameescape(previous_dir))
    if failures == 0 then
        vim.fn.delete(fixture_dir, "d")
    end
    print("RESULT tools: " .. failures .. " failures")
    vim.cmd(failures == 0 and "qa!" or "cquit 1")
end)
