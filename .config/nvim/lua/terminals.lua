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
return M
