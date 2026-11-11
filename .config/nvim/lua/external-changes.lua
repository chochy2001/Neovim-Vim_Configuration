-- Reload buffers that AI agents (or anything else) change on disk.
--
-- Two layers, both in the "external_changes" augroup:
-- 1. checktime on FocusGained, TermLeave and BufEnter: returning to Neovim
--    from another herdr/tmux pane, closing a <leader>a* agent terminal or
--    switching buffers.
-- 2. A file watcher per loaded buffer (vim.uv fs_event: FSEvents on macOS,
--    inotify on Linux, ReadDirectoryChangesW on Windows) for the case where
--    Neovim keeps focus while an agent in another pane edits the open file.
--    CursorHold runs checktime as a fallback where watchers are unreliable.
--
-- Unsaved edits are never overwritten: a modified buffer gets a warning and
-- the user decides (:e! to take the disk version, :w to keep theirs).
local M = {}

local MAX_WATCHERS = 300
local DEBOUNCE_MS = 100
local watchers = {} -- bufnr -> { handle, timer }

local function usable()
    return vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == ""
end

local function stop(buf)
    local w = watchers[buf]
    if not w then
        return
    end
    watchers[buf] = nil
    for _, h in ipairs({ w.handle, w.timer }) do
        if h and not h:is_closing() then
            h:stop()
            h:close()
        end
    end
end

local function watchable(buf, path)
    return path ~= ""
        and vim.bo[buf].buftype == ""
        and not path:match("^%a+://") -- oil://, fugitive://, scp://
        and not path:match("^[/\\][/\\]") -- network share (//host, \\host)
        and vim.uv.fs_stat(path) ~= nil
end

local function disk_mtime(buf)
    local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
    return stat and (stat.mtime.sec .. "." .. stat.mtime.nsec .. ":" .. stat.size) or "missing"
end

local function changed(buf)
    if not vim.api.nvim_buf_is_loaded(buf) or not usable() then
        return
    end
    if vim.bo[buf].modified then
        -- checktime would open a blocking W12 prompt mid-typing; say it once,
        -- and only when the file really changed since it was read or written.
        local mtime = disk_mtime(buf)
        if mtime ~= vim.b[buf].disk_mtime and mtime ~= vim.b[buf].external_warned then
            vim.b[buf].external_warned = mtime
            vim.notify(
                "Changed on disk while you have unsaved edits: "
                    .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":~:.")
                    .. "\n:e! loads the disk version, :w keeps yours.",
                vim.log.levels.WARN
            )
        end
        return
    end
    vim.cmd("checktime " .. buf)
end

function M.watch(buf)
    stop(buf)
    local path = vim.api.nvim_buf_get_name(buf)
    if not vim.bo[buf].modified then
        vim.b[buf].disk_mtime = disk_mtime(buf)
    end
    if not watchable(buf, path) or vim.tbl_count(watchers) >= MAX_WATCHERS then
        return
    end
    local handle, timer = vim.uv.new_fs_event(), vim.uv.new_timer()
    if not handle or not timer then
        return
    end
    local base = vim.fs.basename(path)
    local ok = handle:start(path, {}, function(err, name, events)
        -- On Windows the watch covers the whole folder: ignore other files.
        if err or (name and name ~= "" and vim.fs.basename(name) ~= base) then
            return
        end
        timer:stop()
        timer:start(DEBOUNCE_MS, 0, function()
            vim.schedule(function()
                if watchers[buf] and watchers[buf].handle == handle then
                    changed(buf)
                    -- Agents often write a temp file and rename it over the
                    -- original: the watched inode is gone, so watch the path again.
                    if events.rename and vim.api.nvim_buf_is_valid(buf) then
                        M.watch(buf)
                    end
                end
            end)
        end)
    end)
    if ok then
        watchers[buf] = { handle = handle, timer = timer }
        -- The kernel watch is only registered on the next loop turn, so a
        -- replace that lands first (agents writing twice in a row) is missed:
        -- compare the file once more after that turn.
        vim.defer_fn(function()
            local w = watchers[buf]
            if
                w
                and w.handle == handle
                and vim.b[buf].disk_mtime
                and disk_mtime(buf) ~= vim.b[buf].disk_mtime
            then
                changed(buf)
            end
        end, DEBOUNCE_MS)
    else
        handle:close()
        timer:close()
    end
end

function M.count()
    return vim.tbl_count(watchers)
end

function M.setup()
    vim.opt.autoread = true
    local group = vim.api.nvim_create_augroup("external_changes", { clear = true })
    vim.api.nvim_create_autocmd({ "FocusGained", "TermLeave", "BufEnter" }, {
        group = group,
        callback = function()
            if usable() then
                vim.cmd("checktime")
            end
        end,
    })
    vim.api.nvim_create_autocmd("CursorHold", {
        group = group,
        callback = function(args)
            changed(args.buf)
        end,
    })
    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "BufFilePost" }, {
        group = group,
        callback = function(args)
            M.watch(args.buf)
        end,
    })
    vim.api.nvim_create_autocmd({ "BufUnload", "BufWipeout" }, {
        group = group,
        callback = function(args)
            stop(args.buf)
        end,
    })
    vim.api.nvim_create_autocmd("FileChangedShellPost", {
        group = group,
        callback = function(args)
            vim.notify("Reloaded from disk: " .. vim.fn.fnamemodify(args.file, ":~:."), vim.log.levels.INFO)
        end,
    })
end

return M
