vim.g.mapleader = " "
vim.g.background = "light"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.scrolloff = 8
vim.opt.synmaxcol = 2000
vim.opt.cursorline = true
vim.opt.colorcolumn = "80"

vim.opt.swapfile = false

-- Navigate vim panes better
-- NOTA: Comentado para evitar conflicto con nvim-tmux-navigation
-- que maneja la navegación de ventanas de manera más inteligente
-- vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
-- vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
-- vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
-- vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")
-- Core keymaps - sincronizado con .ideavimrc
vim.keymap.set("i", "jj", "<Esc>")

-- Clear search highlight - sincronizado con IntelliJ
vim.keymap.set("n", "<leader><leader>", ":nohl<CR>", { desc = "Clear search highlight" })

-- Navigation history - sincronizado con IntelliJ
vim.keymap.set("n", "<leader>f", "<C-i>", { desc = "Forward (Go to next location)" })

-- Move lines up/down - sincronizado con IntelliJ
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Indentation in visual mode - sincronizado con IntelliJ
vim.keymap.set("v", ">", ">gv", { desc = "Indent and keep selection" })
vim.keymap.set("v", "<", "<gv", { desc = "Unindent and keep selection" })

-- Center screen on search movements - sincronizado con IntelliJ
vim.keymap.set("n", "n", "nzz", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzz", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "*", "*zz", { desc = "Search word under cursor forward (centered)" })
vim.keymap.set("n", "#", "#zz", { desc = "Search word under cursor backward (centered)" })
vim.keymap.set("n", "g*", "g*zz", { desc = "Search partial word forward (centered)" })
vim.keymap.set("n", "g#", "g#zz", { desc = "Search partial word backward (centered)" })

-- Case conversion in visual mode - sincronizado con IntelliJ
vim.keymap.set("v", "<leader>u", "gu", { desc = "Convert to lowercase" })
vim.keymap.set("v", "<leader>U", "gU", { desc = "Convert to uppercase" })

-- Split navigation - sincronizado con IntelliJ
vim.keymap.set("n", "<space>l", "<C-w>l", { desc = "Go to right split" })
vim.keymap.set("n", "<space>h", "<C-w>h", { desc = "Go to left split" })

-- Window navigation with leader - sincronizado con IntelliJ
vim.keymap.set("n", "<leader>wh", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<leader>wj", "<C-w>j", { desc = "Go to bottom window" })
vim.keymap.set("n", "<leader>wk", "<C-w>k", { desc = "Go to top window" })
vim.keymap.set("n", "<leader>wl", "<C-w>l", { desc = "Go to right window" })

-- Folding commands - sincronizado con IntelliJ
vim.keymap.set("n", "<leader>za", "za", { desc = "Toggle fold" })
vim.keymap.set("n", "<leader>zR", "zR", { desc = "Expand all folds" })
vim.keymap.set("n", "<leader>zM", "zM", { desc = "Collapse all folds" })
vim.keymap.set("n", "<leader>zr", "zr", { desc = "Expand one fold level" })
vim.keymap.set("n", "<leader>zm", "zm", { desc = "Collapse one fold level" })

-- Split/Window management - sincronizado con IntelliJ
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split Vertical" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split Horizontal" })
vim.keymap.set("n", "<leader>sc", ":close<CR>", { desc = "Close Current Split" })
vim.keymap.set("n", "<leader>so", ":only<CR>", { desc = "Close All Other Splits" })
vim.keymap.set("n", "<leader>_", "<C-w>_", { desc = "Maximize Split Height" })

vim.wo.number = true
