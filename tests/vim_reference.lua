-- Generate independent expected states using real, unmapped Neovim.
local cases = vim.json.decode(table.concat(vim.fn.readfile(arg[1]), "\n"))
vim.o.hidden = true
vim.o.shadafile = "NONE"
vim.o.virtualedit = ""
vim.o.backspace = "indent,eol,start"
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
for _, case in ipairs(cases) do
    vim.cmd.enew({ bang = true })
    vim.bo.undolevels = -1
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(case.start, "\n", { plain = true }))
    vim.api.nvim_win_set_cursor(0, { (case.row or 0) + 1, case.col or 0 })
    vim.bo.undolevels = 1000
    vim.cmd.normal({ args = { vim.keycode(case.keys) }, bang = true })
    local pos = vim.api.nvim_win_get_cursor(0)
    case.expected = {
        text = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n"),
        row = pos[1] - 1,
        col = pos[2],
    }
    if case.kataExpected then
        assert(case.kataExpected == case.expected.text, case.id .. ": kata differs from Neovim")
    end
    if type(case.kataColumn) == "number" then
        assert(case.kataColumn == pos[2], case.id .. ": kata cursor differs from Neovim")
    end
end
vim.fn.writefile({ vim.json.encode({ version = tostring(vim.version()), cases = cases }) }, arg[2])
vim.cmd("qa!")
