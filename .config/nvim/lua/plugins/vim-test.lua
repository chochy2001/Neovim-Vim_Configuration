return {
    "vim-test/vim-test",
    dependencies = {
        -- vimux needs a running tmux server (Unix only); skip it on Windows
        -- so startup doesn't warn about a missing tmux executable.
        { "preservim/vimux", cond = vim.fn.has("win32") == 0 },
    },
    config = function()
        -- Test commands: keep only the essentials
        vim.keymap.set("n", "<leader>ten", ":TestNearest<CR>", { desc = "Test: Nearest" })
        vim.keymap.set("n", "<leader>tenf", ":TestFile<CR>", { desc = "Test: File" })
        vim.keymap.set("n", "<leader>tena", ":TestSuite<CR>", { desc = "Test: All Suite" })
        vim.keymap.set("n", "<leader>tenl", ":TestLast<CR>", { desc = "Test: Last" })
        -- TestVisit removed due to infrequent use
        -- vimux requires a live tmux server; use the embedded neovim
        -- terminal on Windows or whenever tmux is absent (all OS).
        local in_tmux = vim.env.TMUX ~= nil and vim.env.TMUX ~= ""
        if vim.fn.has("win32") == 1 or not in_tmux then
            vim.cmd("let test#strategy = 'neovim'")
        else
            vim.cmd("let test#strategy = 'vimux'")
        end
    end,
}
