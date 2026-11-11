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
local function eq(expected, actual)
    assert(
        vim.deep_equal(expected, actual),
        "expected " .. vim.inspect(expected) .. ", got " .. vim.inspect(actual)
    )
end
local errors = {}
local notify = vim.notify
vim.notify = function(msg, level, opts)
    -- Errors, and deprecation warnings: they become errors in the next release.
    if level == vim.log.levels.ERROR or tostring(msg):find("deprecated", 1, true) then
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
test("diagnostic signs and statusline show visible icons", function()
    local signs = vim.diagnostic.config().signs.text
    local want = require("icons").diagnostic_signs()
    for severity, text in pairs(want) do
        assert(signs[severity] == text, "sign " .. severity .. " is " .. vim.inspect(signs[severity]))
        assert(vim.trim(text) ~= "", "blank sign for severity " .. severity)
    end
    local branch = require("lualine").get_config().sections.lualine_b[1]
    assert(branch.icon == require("icons").git_branch and branch.icon ~= "", "branch icon missing")
end)
test("Markdown renders formatted and toggles back to raw", function()
    -- Rendering is redrawn from the main loop, which only runs after startup:
    -- drive a second Neovim with this same isolated config, as a user would.
    local path, out = vim.fn.tempname() .. ".md", vim.fn.tempname()
    vim.fn.writefile({ "# Title", "", "- item", "", "| a | b |", "|---|---|", "| 1 | 2 |" }, path)
    local script = string.format(
        [[
vim.cmd.normal({ args = { "G" }, bang = true })
local ns = vim.api.nvim_create_namespace("render-markdown.nvim")
local function marks()
    return #vim.api.nvim_buf_get_extmarks(0, ns, 0, -1, {})
end
vim.defer_fn(function()
    local rendered = marks()
    vim.api.nvim_feedkeys(vim.keycode("<leader>tm"), "mx", false)
    vim.defer_fn(function()
        vim.fn.writefile({ rendered .. " " .. marks() }, %q)
        vim.cmd("qa!")
    end, 500)
end, 1500)
]],
        out
    )
    local result = vim.system({
        vim.v.progpath,
        "--headless",
        "-u",
        "tests/integration_init.lua",
        path,
        "-c",
        "lua " .. script,
    }):wait(60000)
    assert(result.code == 0, "nvim exited with " .. tostring(result.code))
    local rendered, raw = vim.fn.readfile(out)[1]:match("^(%d+) (%d+)$")
    assert(tonumber(rendered) > 0, "markdown was not rendered")
    assert(tonumber(raw) == 0, "<leader>tm did not show raw markdown")
    vim.fn.delete(path)
    vim.fn.delete(out)
end)
test("the AI workflow: browse a repo, select code, an agent edits it, Neovim reloads", function()
    -- A fake `codex` on PATH records its arguments and rewrites the file like
    -- a real agent (write a temp file, rename it over the original).
    local dir = vim.fn.tempname()
    local bin, repo = dir .. "/bin", dir .. "/repo"
    vim.fn.mkdir(bin, "p")
    vim.fn.mkdir(repo .. "/src", "p")
    vim.fn.writefile({ "# Rules for agents" }, repo .. "/AGENTS.md")
    local file = repo .. "/src/app.lua"
    vim.fn.writefile({ "local x = 1", "local function add(a, b)", "return a+b end", "return add" }, file)
    local args, out = dir .. "/args.txt", dir .. "/out.json"
    local windows = vim.fn.has("win32") == 1
    if windows then
        -- npm shims are .cmd: the config must fall back to the clipboard.
        vim.fn.writefile({ "@echo off", "ping -n 30 127.0.0.1 >nul" }, bin .. "/codex.cmd")
    else
        vim.fn.writefile({
            "#!/bin/sh",
            -- Write then rename: the test polls for the file and must never
            -- read it half written (it did on the Ubuntu runner).
            'printf "%s\\n" "$PWD" "$@" > "$AGENT_ARGS.tmp"',
            'mv "$AGENT_ARGS.tmp" "$AGENT_ARGS"',
            'printf "local x = 1\\nlocal function add(a, b)\\n    return a + b\\nend\\nreturn add\\n" > "$AGENT_FILE.tmp"',
            'mv "$AGENT_FILE.tmp" "$AGENT_FILE"',
            "sleep 30",
        }, bin .. "/codex")
        vim.fn.setfperm(bin .. "/codex", "rwxr-xr-x")
    end
    local script = string.format(
        [==[
vim.defer_fn(function()
    local r = {}
    vim.cmd.cd(%q)
    vim.cmd("Neotree show")
    vim.wait(3000, function() return vim.fn.bufwinid(vim.fn.bufnr("neo-tree filesystem")) ~= -1 or #vim.tbl_filter(function(w) return vim.bo[vim.api.nvim_win_get_buf(w)].filetype == "neo-tree" end, vim.api.nvim_list_wins()) > 0 end)
    r.tree = #vim.tbl_filter(function(w) return vim.bo[vim.api.nvim_win_get_buf(w)].filetype == "neo-tree" end, vim.api.nvim_list_wins()) > 0
    vim.cmd("Neotree close")
    vim.cmd.edit(%q)
    vim.cmd("normal! 2GVj")
    vim.ui.input = function(_, cb) cb("Refactor this") end
    require("ai-terminals").send_visual("codex")
    if %s then
        r.register = vim.fn.getreg("a")
    else
        vim.wait(8000, function() return vim.fn.filereadable(%q) == 1 end)
        r.args = vim.fn.readfile(%q)
        local layout = vim.fn.winlayout()
        local last = layout[1] == "row" and layout[2][#layout[2]]
        r.agent_right = last and last[1] == "leaf" and vim.bo[vim.api.nvim_win_get_buf(last[2])].buftype == "terminal"
        local src = vim.fn.bufnr(%q)
        vim.wait(8000, function() return vim.api.nvim_buf_get_lines(src, 2, 3, false)[1] == "    return a + b" end)
        r.reloaded = vim.api.nvim_buf_get_lines(src, 0, -1, false)
    end
    vim.fn.writefile({ vim.json.encode(r) }, %q)
    vim.cmd("qa!")
end, 1500)
]==],
        repo,
        file,
        tostring(windows),
        args,
        args,
        file,
        out
    )
    local env =
        { AGENT_ARGS = args, AGENT_FILE = file, PATH = bin .. (windows and ";" or ":") .. vim.env.PATH }
    local result = vim.system(
        { vim.v.progpath, "--headless", "-u", "tests/integration_init.lua", "-c", "lua " .. script },
        { env = env }
    ):wait(60000)
    assert(result.code == 0, "nvim exited with " .. tostring(result.code))
    local r = vim.json.decode(vim.fn.readfile(out)[1])
    assert(r.tree, "the file tree did not open")
    if windows then
        assert(r.register:find("Refactor this", 1, true), "prompt not in register a: " .. r.register)
        assert(r.register:find("src/app.lua (lines 2-3)", 1, true), r.register)
    else
        local argv = table.concat(r.args, "\n")
        eq(vim.fs.normalize(vim.uv.fs_realpath(repo)), vim.fs.normalize(vim.uv.fs_realpath(r.args[1])))
        assert(argv:find("Refactor this", 1, true), "instruction missing: " .. argv)
        assert(argv:find("File: src/app.lua (lines 2-3)", 1, true), "location missing: " .. argv)
        assert(argv:find("local function add(a, b)\nreturn a+b end", 1, true), "selection missing: " .. argv)
        assert(r.agent_right, "agent did not open on the right")
        eq({ "local x = 1", "local function add(a, b)", "    return a + b", "end", "return add" }, r.reloaded)
    end
    vim.fn.delete(dir, "rf")
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

test("terminal keys open tmux-style splits and hide them all", function()
    vim.cmd("silent! only")
    -- A process that only ends when killed: the CI runners have no real
    -- console, and their shells sometimes exit on their own there.
    local shell = vim.o.shell
    local exe = vim.v.progpath
    vim.o.shell = (exe:find(" ") and ('"' .. exe .. '"') or exe) .. " --clean"
    local function press(keys)
        if vim.bo.buftype == "terminal" then
            vim.cmd.stopinsert()
            vim.cmd.wincmd("p")
        end
        vim.api.nvim_feedkeys(vim.keycode(keys), "mx", false)
        vim.cmd.stopinsert()
        vim.wait(200)
    end
    local function is_term(win)
        return vim.bo[vim.api.nvim_win_get_buf(win)].buftype == "terminal"
    end
    local function terms()
        return vim.tbl_filter(is_term, vim.api.nvim_tabpage_list_wins(0))
    end
    press(" tv")
    -- Right split: the screen becomes a row whose last cell is the terminal.
    local layout = vim.fn.winlayout()
    assert(layout[1] == "row", "<leader>tv layout: " .. vim.inspect(layout))
    local right = layout[2][#layout[2]]
    assert(right[1] == "leaf" and is_term(right[2]), "<leader>tv did not open on the right")
    local first = vim.api.nvim_win_get_buf(right[2])
    -- Move like the user would after jj, without typing into the shell
    -- (keys fed in terminal mode go to the shell, not to Neovim).
    vim.cmd.stopinsert()
    vim.cmd.wincmd("h")
    press("2 th")
    -- Bottom split: a column whose last cell is a full-width terminal.
    layout = vim.fn.winlayout()
    assert(layout[1] == "col", "2<leader>th did not split at the bottom: " .. vim.inspect(layout))
    local bottom = layout[2][#layout[2]]
    assert(bottom[1] == "leaf" and is_term(bottom[2]), "bottom cell is not a terminal")
    eq(vim.o.columns, vim.api.nvim_win_get_width(bottom[2]))
    assert(vim.api.nvim_win_get_buf(bottom[2]) ~= first, "2<leader>th reused terminal 1")
    eq(2, #terms())
    local function jobs()
        local out = {}
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            local job = vim.bo[buf].buftype == "terminal" and vim.b[buf].terminal_job_id
            if job then
                out[buf] = { status = vim.fn.jobwait({ job }, 0)[1], win = vim.fn.bufwinid(buf) }
            end
        end
        return vim.inspect(out)
    end
    press(" ta")
    assert(#terms() == 0, "<leader>ta left terminals visible: " .. jobs())
    local job = vim.b[first].terminal_job_id
    assert(vim.fn.jobwait({ job }, 0)[1] == -1, "hidden terminal 1 stopped running: " .. jobs())
    local before = vim.api.nvim_get_current_win()
    press(" ta")
    eq(2, #terms())
    eq(before, vim.api.nvim_get_current_win()) -- restored without stealing focus
    press(" tv") -- same key hides terminal 1 again
    local left = terms()
    assert(#left == 1, "<leader>tv did not hide terminal 1: " .. vim.inspect({
        windows = #left,
        mode = vim.api.nvim_get_mode().mode,
        current = vim.bo.buftype,
        jobs = vim.tbl_map(function(win)
            local job = vim.b[vim.api.nvim_win_get_buf(win)].terminal_job_id
            return job and vim.fn.jobwait({ job }, 0)[1]
        end, left),
    }))
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].buftype == "terminal" then
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    end
    vim.o.shell = shell
    vim.cmd("silent! only")
end)
test("IdeaVim keys do the same thing as in Neovim", function()
    -- Each IntelliJ action has the meaning its key must have in Neovim, as a
    -- Lua pattern over the Neovim mapping description. Renaming a key on one
    -- side only, or pointing it at another action, fails here.
    local meaning = {
        ActivateDebugToolWindow = "debug",
        ActivateProblemsViewToolWindow = "diagnostic|list",
        ActivateProjectToolWindow = "neotree|oil|project|explore",
        ActivateRunToolWindow = "overseer",
        ActivateTODOToolWindow = "todo",
        ActivateTerminalToolWindow = "terminal",
        ActivateVersionControlToolWindow = "git",
        Annotate = "blame",
        Back = "back",
        ["ChangesView.Revert"] = "reset",
        CheckinProject = "commit",
        CloseAllEditorsButActive = "close all others",
        CloseAllToTheLeft = "close left",
        CloseAllToTheRight = "close right",
        CloseContent = "close|quit",
        CollapseAllRegions = "collapse all",
        CollapseRegion = "collapse",
        ["Compare.LastVersion"] = "diff",
        ["Compare.SameVersion"] = "diff",
        CompileDirty = "build",
        Debug = "debug",
        ["Diff.ApplyLeftSide"] = "ours",
        ["Diff.ApplyRightSide"] = "theirs",
        ["Diff.NextConflict"] = "conflict|next",
        ["Diff.PreviousConflict"] = "conflict|previous",
        EditBreakpoint = "breakpoint",
        EvaluateExpression = "repl",
        ExpandAllRegions = "expand all",
        ExpandCollapseToggleAction = "toggle fold",
        ExpandRegion = "expand",
        FileStructurePopup = "outline|tagbar",
        FindInPath = "grep",
        FindUsages = "references",
        ["Flutter.DeviceSelector"] = "device",
        ["Flutter.Toolbar.ReloadAction"] = "hot reload",
        ["Flutter.Toolbar.RestartAction"] = "hot restart",
        Forward = "forward",
        ["Git.Add"] = "stage add",
        ["Git.Branches"] = "branch",
        ["Git.Fetch"] = "fetch",
        GotoAction = "commands|keymaps",
        GotoDeclaration = "definition",
        GotoFile = "find files",
        GotoImplementation = "implementation",
        GotoNextBookmark = "harpoon: next",
        GotoNextError = "next error",
        GotoPreviousBookmark = "harpoon: previous",
        GotoPreviousError = "previous error",
        GotoSymbol = "symbol",
        GotoTypeDeclaration = "type definition",
        HelpTopics = "help",
        HideActiveWindow = "close|runner",
        ["LocalHistory.ShowHistory"] = "undo",
        ManageRecentProjects = "project",
        MaximizeEditorInSplit = "maximize",
        NextTab = "next",
        ParameterInfo = "signature",
        PinActiveTabToggle = "pin",
        PreviousTab = "previous",
        RecentFiles = "old files",
        ReformatCode = "format",
        RenameElement = "rename",
        ReplaceInPath = "replace",
        Rerun = "last",
        Resume = "continue",
        Run = "run|test|start",
        RunAnything = "run task",
        RunClass = "run file|test",
        SelectInProjectView = "reveal",
        ShowHoverInfo = "hover",
        ShowBookmarks = "harpoon",
        ShowIntentionActions = "code action",
        SplitHorizontally = "split horizontal",
        SplitVertically = "split vertical",
        StepInto = "step into",
        StepOut = "step out",
        StepOver = "step over",
        Stop = "stop|terminate|quit",
        Switcher = "buffers|pick",
        Synchronize = "build",
        ToggleBookmark = "harpoon: add",
        ToggleDistractionFreeMode = "zen",
        ToggleLineBreakpoint = "toggle breakpoint",
        Unsplit = "close current split",
        UnsplitAll = "close all other splits",
        ["Vcs.Push"] = "push",
        ["Vcs.RollbackChangedLines"] = "reset",
        ["Vcs.Show.Local.Changes"] = "diff|local",
        ["Vcs.Show.Log"] = "history",
        ["Vcs.ShowTabbedFileHistory"] = "history",
        ["Vcs.UpdateProject"] = "pull",
        VcsShowCurrentChangeMarker = "preview",
        VcsShowNextChangeMarker = "next hunk",
        VcsShowPrevChangeMarker = "prev hunk",
        editRunConfigurations = "configuration",
        ["io.flutter.OpenDevToolsAction"] = "devtools",
    }
    -- Keys whose Neovim side is a built-in without a description, or that
    -- only exist in the IDE.
    local builtin = { gr = true, K = true, ["<S-l>"] = true, ["<S-h>"] = true, ["<leader>rr"] = true }
    -- LSP keys are buffer-local and appear on LspAttach.
    local buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_exec_autocmds("LspAttach", { buffer = buf, data = { client_id = 0 } })
    local desc = {}
    for _, map in ipairs(vim.list_extend(vim.api.nvim_get_keymap("n"), vim.api.nvim_buf_get_keymap(buf, "n"))) do
        desc[map.lhs] = (map.desc or ""):lower()
    end
    vim.api.nvim_buf_delete(buf, { force = true })
    local verified = {}
    for _, row in ipairs(vim.fn.readfile("tests/ideavim-actions.tsv")) do
        local id = row:match("^([^#%s]%S*)\t")
        if id then
            verified[id] = true
        end
    end
    local problems, seen = {}, {}
    for number, line in ipairs(vim.fn.readfile(".ideavimrc")) do
        local cmd, lhs, rest = line:match("^%s*(%a*map)%s+(%S+)%s+(.*)$")
        if cmd then
            assert(not seen[cmd .. lhs], ".ideavimrc:" .. number .. " maps " .. lhs .. " twice")
            seen[cmd .. lhs] = true
            local action = rest:match("^<Action>%(([^)]+)%)")
            if action then
                assert(
                    not cmd:find("noremap"),
                    ".ideavimrc:" .. number .. ": <Action> needs map, not noremap"
                )
                if not verified[action] then
                    table.insert(problems, action .. " is not in tests/ideavim-actions.tsv (verify it first)")
                end
                local key = lhs:gsub("^<leader>", " ")
                local want = meaning[action]
                if not want then
                    table.insert(problems, action .. " has no expected meaning in this test")
                elseif not builtin[lhs] then
                    local got = desc[key]
                    local ok = false
                    for alt in want:gmatch("[^|]+") do
                        ok = ok or (got and got:find(alt, 1, true) ~= nil)
                    end
                    if not ok then
                        table.insert(problems, lhs .. " -> " .. action .. " but Neovim: " .. tostring(got))
                    end
                end
            end
        end
    end
    assert(#problems == 0, table.concat(problems, "\n"))
end)
test("practice page cheat sheet lists only real Neovim keys", function()
    -- The page shows every WORKFLOW.md shortcut (built by build_practice.py).
    -- maparg() reads key notation like Neovim does (<A-j> is <M-j>).
    local buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_exec_autocmds("LspAttach", { buffer = buf, data = { client_id = 0 } })
    local builtin = { K = true, ["<C-space>"] = true } -- hover; nvim-cmp's own insert key
    local function mapped(key)
        if builtin[key] then
            return true
        end
        for _, mode in ipairs({ "n", "x", "o", "i", "t" }) do
            if vim.fn.maparg(key, mode) ~= "" then
                return true
            end
            local found = vim.api.nvim_buf_call(buf, function()
                return vim.fn.maparg(key, mode) ~= ""
            end)
            if found then
                return true
            end
        end
        return false
    end
    local data = vim.json.decode(table.concat(vim.fn.readfile("practice/exercises.json"), "\n"))
    local missing, count = {}, 0
    for _, group in ipairs(data.shortcuts) do
        for _, row in ipairs(group.rows) do
            -- Keys of the neo-tree window only exist inside that buffer.
            if not row.mode:find("buffer", 1, true) then
                local keys = {}
                local from, to = row.key:match("^(<leader>)%d %- <leader>%d$"), row.key:match("(%d)$")
                if from then
                    for n = tonumber(row.key:match("(%d) %-")), tonumber(to) do
                        table.insert(keys, "<leader>" .. n)
                    end
                else
                    keys = vim.split(row.key, " / ", { plain = true })
                end
                for _, key in ipairs(keys) do
                    count = count + 1
                    if not mapped(key) then
                        table.insert(missing, key .. " (" .. group.title .. ")")
                    end
                end
            end
        end
    end
    vim.api.nvim_buf_delete(buf, { force = true })
    assert(count > 150, "too few shortcuts checked: " .. count)
    assert(#missing == 0, "WORKFLOW.md keys not mapped in Neovim: " .. table.concat(missing, ", "))
end)
test("opening code files triggers no deprecated API", function()
    -- project.nvim's LSP root detection called vim.lsp.buf_get_clients().
    for _, file in ipairs({ ".config/nvim/lua/icons.lua", "README.md", "scripts/verify.py" }) do
        vim.cmd.edit(file)
        -- project.nvim's BufEnter hook waits for VimEnter, which tests run
        -- before: call the root detection it runs on every buffer.
        require("project_nvim.project").get_project_root()
        vim.wait(100)
    end
    vim.cmd("silent! %bwipeout!")
    -- Nvim's own deprecations and plugin warnings are echoed to :messages,
    -- not sent to vim.notify.
    local messages = vim.fn.execute("messages")
    assert(not messages:find("deprecated", 1, true), messages)
    assert(not messages:find("Failed to find executable", 1, true), messages)
end)
test("no configuration errors or deprecations were notified", function()
    assert(#errors == 0, table.concat(errors, "\n"))
end)
print(string.format("RESULT integration: %d failures", #failures))
vim.cmd(#failures == 0 and "qa!" or "cquit 1")
