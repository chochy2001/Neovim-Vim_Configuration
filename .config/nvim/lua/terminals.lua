local M = {}
local cache = {}
function M.toggle(name)
    local commands = {
        flutter = "flutter",
        lazygit = "lazygit",
        node = "node",
        python = vim.fn.executable("python3") == 1 and "python3" or "python",
        monitor = vim.fn.has("win32") == 1 and "tasklist"
            or (vim.fn.executable("htop") == 1 and "htop" or "top"),
    }
    local cmd = commands[name]
    if not cmd or vim.fn.executable(cmd) ~= 1 then
        vim.notify("Terminal command unavailable: " .. tostring(cmd or name), vim.log.levels.WARN)
        return
    end
    cache[name] = cache[name]
        or require("toggleterm.terminal").Terminal:new({
            cmd = cmd,
            hidden = true,
            direction = "float",
            close_on_exit = false,
        })
    cache[name]:toggle()
end
function M.stop()
    local job = vim.b.terminal_job_id
    if job and vim.fn.jobwait({ job }, 0)[1] == -1 then
        vim.fn.jobstop(job)
        return
    end
    local running = {}
    for _, term in pairs(require("toggleterm.terminal").get_all(true)) do
        if term.job_id and vim.fn.jobwait({ term.job_id }, 0)[1] == -1 then
            table.insert(running, term)
        end
    end
    if #running == 0 then
        vim.notify("No running terminal job", vim.log.levels.INFO)
        return
    end
    vim.ui.select(running, {
        prompt = "Stop terminal:",
        format_item = function(term)
            return term.display_name or term.cmd or ("Terminal " .. term.id)
        end,
    }, function(term)
        if term then
            vim.fn.jobstop(term.job_id)
        end
    end)
end
-- tmux-style split terminals. Number n is one shell that keeps running while
-- hidden. Plain :terminal windows instead of toggleterm: toggleterm puts every
-- new terminal next to the ones already open, so "bottom" could land on the right.
local splits = {} -- n -> { buf = bufnr, direction = "vertical" | "horizontal" }
local hidden = {} -- numbers hidden by toggle_all, to bring back

local function alive(buf)
    if not (buf and vim.api.nvim_buf_is_valid(buf)) then
        return false
    end
    local job = vim.b[buf].terminal_job_id
    return job ~= nil and vim.fn.jobwait({ job }, 0)[1] == -1
end

local function show(n, keep_focus)
    local from = vim.api.nvim_get_current_win()
    local term = splits[n]
    local vertical = term.direction == "vertical"
    vim.cmd(vertical and "botright vsplit" or "botright split")
    if vertical then
        vim.cmd("vertical resize " .. math.floor(vim.o.columns * 0.4))
    else
        vim.cmd("resize " .. math.floor(vim.o.lines * 0.3))
    end
    if alive(term.buf) then
        vim.api.nvim_win_set_buf(0, term.buf)
    else
        vim.cmd.terminal()
        term.buf = vim.api.nvim_get_current_buf()
        vim.bo[term.buf].buflisted = false
        vim.b[term.buf].split_terminal = n
    end
    if keep_focus then
        vim.api.nvim_set_current_win(from)
    else
        vim.cmd.startinsert()
    end
end

--- Open terminal n in a split, or hide it when it is already visible.
---@param direction "vertical"|"horizontal"
---@param n integer|nil
function M.split(direction, n)
    n = n or 1
    local term = splits[n]
    -- Visible (even if its shell already exited): the key hides it.
    if term and term.buf and vim.api.nvim_buf_is_valid(term.buf) and vim.fn.bufwinid(term.buf) ~= -1 then
        vim.api.nvim_win_close(vim.fn.bufwinid(term.buf), false)
        return
    end
    splits[n] = { buf = term and term.buf, direction = direction }
    show(n)
end

--- Hide every visible split terminal, or bring back the ones it hid.
function M.toggle_all()
    local visible = {}
    for n, term in pairs(splits) do
        if vim.api.nvim_buf_is_valid(term.buf or -1) and vim.fn.bufwinid(term.buf) ~= -1 then
            table.insert(visible, n)
        end
    end
    if #visible > 0 then
        hidden = visible
        for _, n in ipairs(visible) do
            vim.api.nvim_win_close(vim.fn.bufwinid(splits[n].buf), false)
        end
        return
    end
    -- Bring them back like tmux panes: the cursor stays where it was.
    for _, n in ipairs(hidden) do
        if splits[n] and alive(splits[n].buf) then
            show(n, true)
        end
    end
    hidden = {}
end

--- Pick any running terminal (split or toggleterm) and jump to it.
function M.pick()
    local items = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].buftype == "terminal" and alive(buf) then
            table.insert(items, buf)
        end
    end
    if #items == 0 then
        vim.notify("No running terminal", vim.log.levels.INFO)
        return
    end
    vim.ui.select(items, {
        prompt = "Terminal:",
        format_item = function(buf)
            local n = vim.b[buf].split_terminal
            return (n and ("Terminal " .. n .. ": ") or "") .. vim.api.nvim_buf_get_name(buf)
        end,
    }, function(buf)
        if not buf then
            return
        end
        local win = vim.fn.bufwinid(buf)
        if win ~= -1 then
            vim.api.nvim_set_current_win(win)
        else
            vim.cmd("botright vsplit")
            vim.api.nvim_win_set_buf(0, buf)
        end
        vim.cmd.startinsert()
    end)
end
return M
