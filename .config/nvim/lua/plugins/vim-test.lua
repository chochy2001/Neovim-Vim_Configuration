return {
    "vim-test/vim-test",
    dependencies = {
        "preservim/vimux",
    },
    config = function()
        -- Test commands: mantener solo los esenciales
        vim.keymap.set("n", "<leader>ten", ":TestNearest<CR>", { desc = "Test: Nearest" })
        vim.keymap.set("n", "<leader>tenf", ":TestFile<CR>", { desc = "Test: File" })
        vim.keymap.set("n", "<leader>tena", ":TestSuite<CR>", { desc = "Test: All Suite" })
        vim.keymap.set("n", "<leader>tenl", ":TestLast<CR>", { desc = "Test: Last" })
        -- TestVisit eliminado por uso poco frecuente
        vim.cmd("let test#strategy = 'vimux'")
    end,
}
