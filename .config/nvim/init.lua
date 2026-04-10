-- Optimization: Compiled Lua module cache (Neovim 0.9+)
vim.loader.enable()

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Core fixes - only the necessary ones after cleanup
pcall(require, "fix-flutter-neotree-conflict") -- Fix for flutter-tools + neo-tree conflict
pcall(require, "lsp-utils") -- LSP utilities and error handling

require("vim-options")
require("lazy").setup("plugins")
