-- telescope lua
local builtin = require("telescope.builtin")
local harpoon = require("harpoon")
harpoon:setup({})
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<C-p>", ":Telescope git_files<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>pf", ":Telescope find_files<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>pg", ":Telescope live_grep<CR>", opts)
vim.keymap.set("n", "<leader>fb", ":Telescope file_browser<CR>", opts)

-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
	local file_paths = {}
	for _, item in ipairs(harpoon_files.items) do
		table.insert(file_paths, item.value)
	end

	require("telescope.pickers")
		.new({}, {
			prompt_title = "Harpoon",
			finder = require("telescope.finders").new_table({
				results = file_paths,
			}),
			previewer = conf.file_previewer({}),
			sorter = conf.generic_sorter({}),
		})
		:find()
end

vim.keymap.set("n", "<C-e>", function()
	toggle_telescope(harpoon:list())
end, { desc = "Open harpoon window" })
