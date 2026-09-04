-- Optimization: Compiled Lua module cache (Neovim 0.9+)
vim.loader.enable()

-- Neovim 0.11+ renamed vim.highlight -> vim.hl. Some plugins (git-conflict
-- 2.1) still read vim.highlight.priorities and trip a deprecation warning.
if vim.hl then
    rawset(vim, "highlight", vim.hl)
end

-- git-conflict still uses the table form of vim.validate with type aliases
-- ('n','s',...). Neovim 0.12 form-1 does not accept those aliases, so map
-- them before calling the native API (also avoids the table-form deprecation).
do
    local orig = vim.validate
    local aliases = {
        b = "boolean",
        c = "callable",
        f = "function",
        n = "number",
        s = "string",
        t = "table",
    }
    local function map_validator(validator)
        if type(validator) == "string" then
            return aliases[validator] or validator
        end
        if type(validator) == "table" then
            local mapped = {}
            for i, t in ipairs(validator) do
                mapped[i] = type(t) == "string" and (aliases[t] or t) or t
            end
            return mapped
        end
        return validator
    end
    vim.validate = function(name, value, validator, optional, message)
        if type(name) == "table" and value == nil then
            for k, spec in pairs(name) do
                orig(k, spec[1], map_validator(spec[2]), spec[3], spec[4])
            end
            return
        end
        return orig(name, value, map_validator(validator), optional, message)
    end
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    if vim.fn.executable("git") ~= 1 then
        vim.notify(
            "lazy.nvim bootstrap needs `git` on PATH (Windows: `winget install Git.Git`)",
            vim.log.levels.ERROR
        )
    else
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath,
        })
    end
end
vim.opt.rtp:prepend(lazypath)

-- Core fixes - only the necessary ones after cleanup
pcall(require, "fix-flutter-neotree-conflict") -- Fix for flutter-tools + neo-tree conflict
pcall(require, "lsp-utils") -- LSP utilities and error handling

require("vim-options")
require("lazy").setup("plugins")
