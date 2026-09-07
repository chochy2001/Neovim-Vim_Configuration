-- Require the stable API used by this configuration.
if vim.fn.has("nvim-0.12") ~= 1 then
    error("This configuration requires Neovim 0.12 or later")
end
vim.loader.enable()
require("vim-options")

-- NVIM_OFFLINE disables automatic plugin/tool/parser downloads.
-- Existing installed plugins remain usable; explicit update commands still work.
local offline = vim.env.NVIM_OFFLINE == "1"
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    assert(not offline, "lazy.nvim is missing; install plugins once without NVIM_OFFLINE=1")
    assert(vim.fn.executable("git") == 1, "lazy.nvim bootstrap needs git on PATH")
    local output = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
    assert(vim.v.shell_error == 0, "lazy.nvim bootstrap failed: " .. output)
end
vim.opt.rtp:prepend(lazypath)
require("lsp-utils")
require("lazy").setup("plugins", {
    install = { missing = not offline },
    checker = { enabled = false },
    change_detection = { notify = false },
})
