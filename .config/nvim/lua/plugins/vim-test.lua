return {
    "vim-test/vim-test",
    dependencies = {
        "preservim/vimux",
    },
    config = function()
        -- Test commands: mantener solo los esenciales
        vim.keymap.set("n", "<leader>T", ":TestNearest<CR>", { desc = "Test: Nearest" })
        vim.keymap.set("n", "<leader>Tf", ":TestFile<CR>", { desc = "Test: File" })
        vim.keymap.set("n", "<leader>Ta", ":TestSuite<CR>", { desc = "Test: All Suite" })
        vim.keymap.set("n", "<leader>Tl", ":TestLast<CR>", { desc = "Test: Last" })
        -- TestVisit eliminado por uso poco frecuente
        vim.cmd("let test#strategy = 'vimux'")
    end,
}
