-- CLI sessions are opened on demand. Capture prompts before opening UI.
local M = {}
local assistants = {
    opencode = { cmd = "opencode", hint = "npm i -g opencode-ai" },
    codex = { cmd = "codex", hint = "npm i -g @openai/codex" },
    claude = { cmd = "claude", hint = "install Claude Code and add claude to PATH" },
    gemini = { cmd = "gemini", hint = "npm i -g @google/gemini-cli" },
    grok = { cmd = "grok", hint = "configure your chosen grok CLI on PATH" },
    copilot = { cmd = "copilot", hint = "npm i -g @github/copilot" },
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
    if vim.fn.executable(a.cmd) ~= 1 then
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
local function prepare(name, selection)
    vim.ui.input({ prompt = "AI (" .. name .. ") instruction: " }, function(instruction)
        if not instruction or instruction == "" then
            return
        end
        local fence = string.rep(string.char(96), 3)
        local prompt = instruction .. "\n\n" .. fence .. "\n" .. selection .. "\n" .. fence
        -- Register a also works over SSH without a clipboard provider.
        vim.fn.setreg("a", prompt)
        local clipboard = vim.fn.has("clipboard") == 1 and pcall(vim.fn.setreg, "+", prompt)
        local term = ensure(name)
        if not term then
            return
        end
        term:open()
        -- These TUIs have no shared ready signal. Never guess with a timer:
        -- it could submit a partial prompt or paste into an exited CLI.
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
    prepare(name, selection)
end
function M.send_visual_pick()
    local selection, err = capture()
    if not selection then
        vim.notify("AI: " .. err, vim.log.levels.WARN)
        return
    end
    vim.ui.select(M.names(), { prompt = "Prepare selection for AI:" }, function(choice)
        if choice then
            prepare(choice, selection)
        end
    end)
end
function M.names()
    local names = vim.tbl_keys(assistants)
    table.sort(names)
    return names
end
return M
