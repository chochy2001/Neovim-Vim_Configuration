return {
    "vim-test/vim-test",
    dependencies = {
        "preservim/vimux",
    },
    config = function()
        -- Test commands: keep only the essentials
        vim.keymap.set("n", "<leader>ten", ":TestNearest<CR>", { desc = "Test: Nearest" })
        vim.keymap.set("n", "<leader>tenf", ":TestFile<CR>", { desc = "Test: File" })
        vim.keymap.set("n", "<leader>tena", ":TestSuite<CR>", { desc = "Test: All Suite" })
        vim.keymap.set("n", "<leader>tenl", ":TestLast<CR>", { desc = "Test: Last" })
        -- TestVisit removed due to infrequent use
        -- vimux requires tmux (Unix); on Windows use neovim terminal
        if vim.fn.has("win32") == 1 then
            vim.cmd("let test#strategy = 'neovim'")
        else
            vim.cmd("let test#strategy = 'vimux'")
        end
    end,
}
