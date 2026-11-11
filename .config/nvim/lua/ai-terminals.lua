-- CLI sessions are opened on demand. Capture prompts before opening UI.
local M = {}
-- `start` turns a prompt into the CLI arguments that open an interactive
-- session already working on it (checked in each CLI's --help). kimi has no
-- such flag: its prompt goes through the clipboard instead.
local function positional(prompt)
    return { prompt }
end
local assistants = {
    opencode = {
        cmd = "opencode",
        hint = "npm i -g opencode-ai",
        start = function(prompt)
            return { "--prompt", prompt }
        end,
    },
    codex = { cmd = "codex", hint = "npm i -g @openai/codex", start = positional },
    claude = { cmd = "claude", hint = "install Claude Code and add claude to PATH", start = positional },
    gemini = {
        cmd = "gemini",
        hint = "npm i -g @google/gemini-cli",
        start = function(prompt)
            return { "-i", prompt }
        end,
    },
    grok = { cmd = "grok", hint = "configure your chosen grok CLI on PATH", start = positional },
    copilot = {
        cmd = "copilot",
        hint = "npm i -g @github/copilot",
        start = function(prompt)
            return { "-i", prompt }
        end,
    },
    cursor = {
        cmd = "cursor-agent",
        hint = vim.fn.has("win32") == 1 and "install the Cursor CLI from cursor.com/cli"
            or "curl https://cursor.com/install -fsS | bash",
        start = positional,
    },
    antigravity = {
        cmd = "agy",
        hint = "install Antigravity and enable its agy CLI",
        start = function(prompt)
            return { "-i", prompt }
        end,
    },
    muse = { cmd = "muse", hint = "install the muse CLI and add it to PATH", start = positional },
    kimi = { cmd = "kimi", hint = "install Kimi Code CLI and add kimi to PATH" },
}
local terms = {}

-- Native getregion handles character/line/block selections and UTF-8.
function M.get_visual_text()
    local first, last = vim.fn.getpos("'<"), vim.fn.getpos("'>")
    if first[2] == 0 or last[2] == 0 then
        return nil, "no visual selection"
    end
    local ok, lines = pcall(vim.fn.getregion, first, last, {
        type = vim.fn.visualmode(),
        exclusive = vim.o.selection == "exclusive",
    })
    if not ok or #lines == 0 then
        return nil, "could not read selection"
    end
    return table.concat(lines, "\n")
end
local function capture()
    local mode = vim.fn.mode()
    if mode == "v" or mode == "V" or mode == string.char(22) then
        vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
    end
    return M.get_visual_text()
end
local function ensure(name)
    local a = assistants[name]
    if not a then
        vim.notify("Unknown AI assistant: " .. tostring(name), vim.log.levels.ERROR)
        return
    end
    -- A command may carry flags ("grok --flag"): check only the program.
    if vim.fn.executable(a.cmd:match("^%S+")) ~= 1 then
        vim.notify("AI CLI missing: " .. a.cmd .. ". " .. a.hint, vim.log.levels.WARN)
        return
    end
    terms[name] = terms[name]
        or require("toggleterm.terminal").Terminal:new({
            cmd = a.cmd,
            hidden = true,
            direction = "float",
            float_opts = { border = "double" },
        })
    return terms[name]
end
function M.toggle(name)
    local term = ensure(name)
    if term then
        term:toggle()
    end
end
-- Where the selection lives, so the agent edits the right place.
local function location()
    local file = vim.api.nvim_buf_get_name(0)
    local first, last = vim.fn.line("'<"), vim.fn.line("'>")
    local root = vim.fs.root(0, { ".git", "AGENTS.md" }) or vim.fn.getcwd()
    local rel = file ~= "" and vim.fs.relpath(root, file) or nil
    return root, rel and string.format("%s (lines %d-%d)", rel, first, last)
end

function M.build_prompt(instruction, selection, where)
    local fence = string.rep(string.char(96), 3)
    local header = where and ("File: " .. where .. "\n\n") or ""
    return header .. instruction .. "\n\n" .. fence .. "\n" .. selection .. "\n" .. fence
end

-- Starting the CLI with its prompt needs a real executable: Windows npm
-- shims (.cmd/.bat) run through cmd.exe, which mangles multi-line arguments.
local function can_start(a)
    if not a.start then
        return false
    end
    local exe = vim.fn.exepath(a.cmd:match("^%S+"))
    return exe ~= "" and not exe:lower():match("%.cmd$") and not exe:lower():match("%.bat$")
end

-- Open the agent on the right, in the project root (where it reads
-- AGENTS.md), already working on the prompt.
local function start_task(a, prompt, root)
    local argv = vim.split(a.cmd, " ", { trimempty = true })
    vim.list_extend(argv, a.start(prompt))
    vim.cmd("botright vsplit")
    vim.cmd("vertical resize " .. math.floor(vim.o.columns * 0.45))
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(0, buf)
    local job = vim.fn.jobstart(argv, { term = true, cwd = root })
    if job <= 0 then
        vim.api.nvim_win_close(0, true)
        return false
    end
    vim.b[buf].ai_task = a.cmd
    vim.cmd.startinsert()
    return true
end

local function prepare(name, selection, root, where)
    vim.ui.input({ prompt = "AI (" .. name .. ") instruction: " }, function(instruction)
        if not instruction or instruction == "" then
            return
        end
        local prompt = M.build_prompt(instruction, selection, where)
        -- Register a also works over SSH without a clipboard provider.
        vim.fn.setreg("a", prompt)
        local a = assistants[name]
        if not ensure(name) then
            return
        end
        -- The agent edits the file on disk: save first so it sees what you see.
        vim.cmd("silent! update")
        if can_start(a) and start_task(a, prompt, root) then
            vim.notify(
                "AI: " .. a.cmd .. " is working on it. Changes reload here when it saves.",
                vim.log.levels.INFO
            )
            return
        end
        local clipboard = vim.fn.has("clipboard") == 1 and pcall(vim.fn.setreg, "+", prompt)
        terms[name]:open()
        -- No initial-prompt flag (or a Windows shim): never guess when the TUI
        -- is ready with a timer, it could submit half a prompt.
        vim.notify(
            clipboard and "Prompt copied. Paste in the CLI when ready, review, then submit."
                or 'Prompt in register a. In terminal-normal mode use "ap, review, then submit.',
            vim.log.levels.INFO
        )
    end)
end
function M.send_visual(name)
    local selection, err = capture()
    if not selection then
        vim.notify("AI: " .. err, vim.log.levels.WARN)
        return
    end
    prepare(name, selection, location())
end
function M.send_visual_pick()
    local selection, err = capture()
    if not selection then
        vim.notify("AI: " .. err, vim.log.levels.WARN)
        return
    end
    local root, where = location()
    vim.ui.select(M.names(), { prompt = "Send selection to AI:" }, function(choice)
        if choice then
            prepare(choice, selection, root, where)
        end
    end)
end
function M.has_command(cmd)
    for _, a in pairs(assistants) do
        if a.cmd:match("^%S+") == cmd then
            return true
        end
    end
    return false
end
function M.names()
    local names = vim.tbl_keys(assistants)
    table.sort(names)
    return names
end
return M
