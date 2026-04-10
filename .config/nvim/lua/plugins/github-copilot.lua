-- lua/plugins/copilot.lua

return {
	-- GitHub Copilot inline completions
	{
		"github/copilot.vim",
		event = { "InsertEnter", "BufEnter" },

		-- Use 'init' to configure global variables BEFORE the plugin loads
		init = function()
			-- Disable Copilot for certain file types
			-- See ':help copilot-filetypes' after installing for exact syntax
			vim.g.copilot_filetypes = {
				["*"] = true, -- Enabled for all by default
				-- Examples to disable:
				-- yaml = false,
				-- markdown = false,
				-- help = false,
				-- gitcommit = false,
				-- gitrebase = false,
				-- hgcommit = false,
				-- svn = false,
				-- cvs = false,
				-- dbout = false,
				["--"] = false, -- Files without extension
			}

			-- Disable the default <Tab> mapping if it interferes with other plugins
			-- If set to 1, you'll need to manually map acceptance (see note below)
			-- vim.g.copilot_no_tab_map = 1

			-- Copilot requires Node.js 22+ (auto-detect nvm or system node)
			local nvm_node = vim.fn.expand("$HOME/.nvm/versions/node")
			local nvm_dirs = vim.fn.glob(nvm_node .. "/v22*", false, true)
			if #nvm_dirs > 0 then
				vim.g.copilot_node_command = nvm_dirs[#nvm_dirs] .. "/bin/node"
			end
		end,
	},

	-- Interactive AI chat for code assistance
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			"github/copilot.vim",
			"nvim-lua/plenary.nvim",
		},
		build = "make tiktoken",
		cmd = { "CopilotChat", "CopilotChatOpen", "CopilotChatToggle" },
		keys = {
			{ "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Copilot: Toggle Chat" },
			{ "<leader>ce", "<cmd>CopilotChatExplain<cr>", mode = { "n", "v" }, desc = "Copilot: Explain" },
			{ "<leader>cr", "<cmd>CopilotChatReview<cr>", mode = { "n", "v" }, desc = "Copilot: Review" },
			{ "<leader>cf", "<cmd>CopilotChatFix<cr>", mode = { "n", "v" }, desc = "Copilot: Fix" },
			{ "<leader>co", "<cmd>CopilotChatOptimize<cr>", mode = { "n", "v" }, desc = "Copilot: Optimize" },
			{ "<leader>ct", "<cmd>CopilotChatTests<cr>", mode = { "n", "v" }, desc = "Copilot: Generate Tests" },
		},
		opts = {
			window = {
				layout = "float",
				width = 0.8,
				height = 0.8,
			},
		},
	},
}
