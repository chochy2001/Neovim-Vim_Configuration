-- Optimization: Compiled Lua module cache (Neovim 0.9+)
vim.loader.enable()

-- Neovim 0.11+ renamed vim.highlight -> vim.hl. Some plugins (git-conflict
-- 2.1) still read vim.highlight.priorities and trip a deprecation warning.
if vim.hl then
    rawset(vim, "highlight", vim.hl)
end

-- git-conflict/colors.lua still uses the table form of vim.validate, which
-- Neovim 0.11+ deprecates. Translate that form so the warning never fires.
do
    local orig = vim.validate
    vim.validate = function(name, value, validator, optional, message)
        if type(name) == "table" and value == nil then
            for k, spec in pairs(name) do
                orig(k, spec[1], spec[2], spec[3], spec[4])
            end
            return
        end
        return orig(name, value, validator, optional, message)
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
