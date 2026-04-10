-- SMART suppressor - Only silences messages, does NOT break functionality
-- Allows functions to work normally, only hides visual errors

-- 1. ONLY intercept vim.notify for specific error messages
local original_notify = vim.notify
vim.notify = function(msg, level, opts)
    if type(msg) == "string" then
        -- Error patterns we want to silence VISUALLY
        local error_patterns = {
            "E5248.*Invalid character in group name",
            "BufWinLeave Autocommands",
            "BufModifiedSet Autocommands",
            "nvim_exec2.*Error executing lua callback",
            "attempt to index field 'cmd'",
            "Error opening file.*vim/_editor%.lua"
        }

        for _, pattern in ipairs(error_patterns) do
            if msg:find(pattern) then
                -- Log suppressed errors for debugging (optional)
                local log_file = vim.fn.stdpath("cache") .. "/suppressed_errors.log"
                local f = io.open(log_file, "a")
                if f then
                    f:write(os.date("[%Y-%m-%d %H:%M:%S] ") .. "SUPPRESSED: " .. msg .. "\n")
                    f:close()
                end
                return -- Silence ONLY the visual message
            end
        end
    end

    -- For all other messages, show normally
    return original_notify(msg, level, opts)
end

-- 2. Intercept vim.api.nvim_echo ONLY for specific errors
local original_echo = vim.api.nvim_echo
vim.api.nvim_echo = function(chunks, history, opts)
    if type(chunks) == "table" then
        local should_suppress = false

        -- Check if any chunk contains errors we want to silence
        for _, chunk in ipairs(chunks) do
            if type(chunk) == "table" and type(chunk[1]) == "string" then
                if chunk[1]:find("E5248") or
                   chunk[1]:find("Invalid character in group name") or
                   chunk[1]:find("BufWinLeave Autocommands") then
                    should_suppress = true
                    break
                end
            end
        end

        if should_suppress then
            return -- Do not show this specific echo
        end
    end

    return original_echo(chunks, history, opts)
end

-- 3. Intercept vim.api.nvim_err_write ONLY for E5248 errors
local original_err_write = vim.api.nvim_err_write
vim.api.nvim_err_write = function(str)
    if type(str) == "string" and str:find("E5248") then
        return -- Do not write E5248 errors specifically
    end
    return original_err_write(str)
end

-- 4. Clean vim.v.errmsg periodically WITHOUT breaking anything else
vim.schedule(function()
    local cleanup_timer = vim.uv.new_timer()
    cleanup_timer:start(100, 1000, vim.schedule_wrap(function()
        if vim.v.errmsg and (vim.v.errmsg:find("E5248") or vim.v.errmsg:find("BufWinLeave")) then
            vim.v.errmsg = ""
        end
    end))
end)

-- DO NOT TOUCH vim.cmd, vim.api.nvim_set_hl, or other critical functions
-- Only silence visual error messages

-- SMART suppressor activated - only hides specific error messages