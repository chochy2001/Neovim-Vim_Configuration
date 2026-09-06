-- lua/plugins/copilot.lua

return {
	-- GitHub Copilot inline completions
	{
		"github/copilot.vim",
		event = "InsertEnter",

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
				[""] = false,
			}

			-- Disable the default <Tab> mapping if it interferes with other plugins
			-- If set to 1, you'll need to manually map acceptance (see note below)
			-- vim.g.copilot_no_tab_map = 1

			-- Copilot requires Node.js 22+ (auto-detect nvm/fnm or system node).
			-- On Windows check %APPDATA%/nvm and fnm dirs too; otherwise leave
			-- unset so copilot.vim falls back to node in PATH (all OS).
			local nvm_roots = { vim.fn.expand("$HOME/.nvm/versions/node") }
			if vim.fn.has("win32") == 1 then
				table.insert(nvm_roots, vim.fn.expand("$APPDATA/nvm"))
			end
			-- fnm lives in ~/.local/share/fnm on every OS
			local fnm_home = vim.fn.expand("$HOME/.local/share/fnm")
			if vim.fn.isdirectory(fnm_home) == 1 then
				table.insert(nvm_roots, fnm_home)
			end
			for _, root in ipairs(nvm_roots) do
				local dirs = vim.fn.glob(root .. "/v22*", false, true)
				if #dirs > 0 then
					local unix = dirs[#dirs] .. "/bin/node"
					local win = dirs[#dirs] .. "\\node.exe"
					if vim.fn.executable(unix) == 1 then
						vim.g.copilot_node_command = unix
						break
					end
					if vim.fn.executable(win) == 1 then
						vim.g.copilot_node_command = win
						break
					end
				end
			end
		end,
	},

	-- Interactive AI chat (run :Copilot auth first to authenticate)
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			"github/copilot.vim",
			"nvim-lua/plenary.nvim",
		},
		-- tiktoken needs a C compiler via make; skip the build step on systems
		-- without make (e.g. stock Windows) instead of failing the install.
		build = vim.fn.executable("make") == 1 and "make tiktoken" or nil,
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
			show_help = false,
			window = {
				layout = "float",
				width = 0.8,
				height = 0.8,
			},
			-- Suppress auth errors on startup (user can run :Copilot auth when ready)
			on_error = function(err)
				if type(err) == "string" and err:match("Bad credentials") then
					return -- silently ignore auth errors
				end
				vim.notify("CopilotChat: " .. tostring(err), vim.log.levels.WARN)
			end,
		},
	},
}
