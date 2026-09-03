-- AI coding assistants (opencode, codex, claude, gemini, grok, copilot).
-- Plain module: creates one cached floating terminal per assistant on first
-- use. Each CLI keeps its own subscription/login, so there are no API keys
-- to configure in Neovim. Keymaps live in lua/plugins/ai-terminal.lua and
-- load toggleterm on first press, so this module always runs with the
-- plugin (and its setup from terminal.lua) already loaded.
local M = {}

local assistants = {
    opencode = { cmd = "opencode", hint = "npm i -g opencode-ai" },
    codex = { cmd = "codex", hint = "npm i -g @openai/codex" },
    claude = { cmd = "claude", hint = "npm i -g @anthropic-ai/claude-code" },
    gemini = { cmd = "gemini", hint = "npm i -g @google/gemini-cli" },
    grok = { cmd = "grok", hint = "install the xAI grok CLI and add it to PATH" },
    copilot = { cmd = "copilot", hint = "npm i -g @github/copilot" },
}

local terms = {}

--- Return the current visual selection (`<`/`>` marks) as a string.
--- Pure function over the current buffer: safe to unit-test headless.
---@return string|nil text, string|nil err
function M.get_visual_text()
    local bufnr = vim.api.nvim_get_current_buf()
    local start_pos = vim.api.nvim_buf_get_mark(bufnr, "<")
    local end_pos = vim.api.nvim_buf_get_mark(bufnr, ">")
    if start_pos[1] == 0 or end_pos[1] == 0 then
        return nil, "no visual selection"
    end
    local srow, erow = start_pos[1], end_pos[1]
    if srow > erow then
        srow, erow = erow, srow
    end
    local ok, lines = pcall(vim.api.nvim_buf_get_lines, bufnr, srow - 1, erow, false)
    if not ok or #lines == 0 then
        return nil, "could not read selection"
    end
    return table.concat(lines, "\n"), nil
end

--- Ensure the floating terminal for `name` exists and return it (or nil).
local function ensure(name)
    local a = assistants[name]
    if not a then
        vim.notify("Unknown AI assistant: " .. tostring(name), vim.log.levels.ERROR)
        return nil
    end
    if vim.fn.executable(a.cmd) ~= 1 then
        vim.notify(
            string.format("AI CLI '%s' not found in PATH. Install it with: %s", a.cmd, a.hint),
            vim.log.levels.WARN
        )
        return nil
    end
    if not terms[name] then
        local ok, toggleterm_terminal = pcall(require, "toggleterm.terminal")
        if not ok then
            vim.notify("toggleterm.nvim is not available", vim.log.levels.ERROR)
            return nil
        end
        terms[name] = toggleterm_terminal.Terminal:new({
            cmd = a.cmd,
            hidden = true,
            direction = "float",
            float_opts = { border = "double" },
            on_open = function(term)
                vim.cmd("startinsert!")
                vim.keymap.set(
                    "n",
                    "q",
                    "<cmd>close<CR>",
                    { buffer = term.bufnr, noremap = true, silent = true }
                )
            end,
        })
    end
    return terms[name]
end

function M.toggle(name)
    local term = ensure(name)
    if term then
        term:toggle()
    end
end

--- Visual workflow: send the current selection to `name` with an
--- instruction typed by the user. The composed prompt is also left in the
--- `+` register as a paste fallback, so nothing is ever lost if the TUI
--- is still booting when the text is sent.
---@param name string assistant key from `assistants`
function M.send_visual(name)
    -- Leave visual mode first so the `<`/`>` marks settle, then work async.
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
    vim.schedule(function()
        local text, err = M.get_visual_text()
        if not text then
            vim.notify("AI: " .. (err or "empty selection"), vim.log.levels.WARN)
            return
        end
        vim.ui.input({ prompt = "AI (" .. name .. ") instruction: " }, function(instruction)
            if not instruction or instruction == "" then
                return
            end
            local prompt = instruction .. "\n\n```\n" .. text .. "\n```"
            pcall(vim.fn.setreg, "+", prompt)
            local term = ensure(name)
            if not term then
                return -- prompt is still in the clipboard for manual paste
            end
            term:open()
            vim.defer_fn(function()
                -- send() appends CR itself (see toggleterm source); pcall
                -- covers the case where the TUI job is not ready yet.
                local ok = pcall(function()
                    term:send(prompt, false)
                end)
                vim.notify(
                    ok and ("Prompt sent to " .. name .. " (backup copy in clipboard)")
                        or "Terminal not ready: prompt is in the clipboard, paste it manually",
                    ok and vim.log.levels.INFO or vim.log.levels.WARN
                )
            end, 900)
        end)
    end)
end

--- Visual workflow with assistant picker: choose any configured agent for
--- the occasion, type the instruction, and the selection is sent to it.
function M.send_visual_pick()
    vim.ui.select(M.names(), { prompt = "Send selection to AI:" }, function(choice)
        if choice then
            M.send_visual(choice)
        end
    end)
end

function M.names()
    local out = {}
    for name in pairs(assistants) do
        table.insert(out, name)
    end
    table.sort(out)
    return out
end

return M
