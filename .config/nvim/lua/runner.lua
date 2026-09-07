-- Commands for small standalone files. Projects use Overseer.
local M = {}
local function quote(value)
    if vim.fn.has("win32") == 1 then
        if vim.o.shell:lower():match("powershell") or vim.o.shell:lower():match("pwsh") then
            return "'" .. value:gsub("'", "''") .. "'"
        end
        assert(not value:find('[%%!"]'), "Use PowerShell for paths containing %, ! or quotes")
        return '"' .. value .. '"'
    end
    return "'" .. value:gsub("'", "'\\''") .. "'"
end
M.quote = quote
function M.command(ft, path)
    local win = vim.fn.has("win32") == 1
    local pwsh = win and (vim.o.shell:lower():match("powershell") or vim.o.shell:lower():match("pwsh"))
    local function command(argv)
        local out = {}
        for _, value in ipairs(argv) do
            table.insert(out, quote(value))
        end
        return (pwsh and "& " or "") .. table.concat(out, " ")
    end
    local python = vim.fn.executable("python3") == 1 and "python3" or "python"
    local simple = {
        python = { python, "-u", path },
        javascript = { "node", path },
        typescript = vim.fn.executable("deno") == 1 and { "deno", "run", path } or { "node", path },
        dart = { "dart", path },
        go = { "go", "run", path },
        java = { "java", path },
        swift = { "swift", path },
    }
    local output = vim.fn.tempname() .. (win and ".exe" or "")
    local compiler = { c = "gcc", cpp = "g++", rust = "rustc", kotlin = "kotlinc" }
    local argv = simple[ft]
    local build
    if compiler[ft] then
        if ft == "kotlin" then
            output = vim.fn.tempname() .. ".jar"
            build = { "kotlinc", path, "-include-runtime", "-d", output }
            argv = { "java", "-jar", output }
        else
            build = { compiler[ft], path, "-o", output }
            argv = { output }
        end
    end
    if not argv then
        vim.notify("No standalone runner for " .. ft .. "; use :OverseerRun", vim.log.levels.WARN)
        return
    end
    for _, bin in ipairs(build and { build[1], ft == "kotlin" and "java" or build[1] } or { argv[1] }) do
        if vim.fn.executable(bin) ~= 1 then
            vim.notify("Runner needs " .. bin .. " on PATH", vim.log.levels.WARN)
            return
        end
    end
    local run = command(argv)
    if build then
        run = command(build) .. (pwsh and ("; if ($LASTEXITCODE -eq 0) { " .. run .. " }") or (" && " .. run))
    end
    local cd = pwsh and "Set-Location -LiteralPath " or (win and "cd /d " or "cd ")
    return cd .. quote(vim.fn.fnamemodify(path, ":h")) .. (pwsh and "; " or " && ") .. run
end
return M
