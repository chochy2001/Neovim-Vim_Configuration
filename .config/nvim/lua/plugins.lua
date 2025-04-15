local fn = vim.fn

-- Auto-instalar Packer si no está instalado
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Instalando Packer... cierra y vuelve a abrir Neovim.")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocomando que recarga Neovim cada vez que se guarda plugins.lua
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Manejo seguro de 'require'
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	vim.notify("Error: No se pudo cargar Packer", vim.log.levels.ERROR)
	return
end

-- Configuración de Packer para usar una ventana emergente
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- [[ INICIO DE LA LISTA DE PLUGINS ]] --
return require("packer").startup(function(use)
	-- Core Packer
	use("wbthomason/packer.nvim")

	-- Dependencias y Utilidades
	use("nvim-lua/plenary.nvim")
	use("nvim-tree/nvim-web-devicons")

	-- Formateo
	use({
		"stevearc/conform.nvim",
		-- event = { "BufWritePre" },
		-- cmd = { "ConformInfo" },
		config = function()
			local conform = require("conform")
			conform.setup({
				notify_on_error = false,
				lsp_fallback = true,
				formatters_by_ft = {
					lua = { "stylua" },
					go = { "gofmt", "golines" },
					java = { "google-java-format" },
					kotlin = { "ktlint" },
					dart = { "dart_format" },
					swift = { "swift_format" },
					sql = { "sqlfluff" },
					sh = { "shfmt" },
					xml = { "xmllint" },
					python = { "black", "isort" },
					c = { "clang_format" },
					cpp = { "clang_format" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					javascriptreact = { "prettier" },
					typescriptreact = { "prettier" },
					json = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
					html = { "prettier" },
					css = { "prettier" },
					scss = { "prettier" },
				},
				formatters = {
					swift_format = {
						command = "swift-format",
					},
					shfmt = { prepend_args = { "-i", "2" } },
					sqlfluff = { command = "sqlfluff", args = { "format", "--dialect", "ansi", "-" }, stdin = true },
					prettier = { args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) } },
				},
				format_on_save = {
					timeout_ms = 3000,
					lsp_fallback = true,
				},
			})
			vim.api.nvim_create_user_command("FormatInfo", function()
				conform.info()
			end, {})
		end,
	})

	-- Snippets
	use("L3MON4D3/LuaSnip")
	use("rafamadriz/friendly-snippets")
	use("saadparwaiz1/cmp_luasnip")

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"dart",
					"go",
					"typescript",
					"javascript",
					"java",
					"kotlin",
					"c",
					"lua",
					"vim",
					"vimdoc",
					"query",
					"markdown",
					"markdown_inline",
					"sql",
					"html",
					"css",
					"json",
					"yaml",
					"bash",
				},
				sync_install = false,
				auto_install = true,
				highlight = { enable = true },
				rainbow = { enable = true, extended_mode = true, max_file_lines = 1000 },
			})
		end,
	})
	use("nvim-treesitter/playground")

	-- Movimiento / Edición
	use({
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	use("mbbill/undotree")
	use("tpope/vim-surround")
	use("easymotion/vim-easymotion")
	use({
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({})
			local cmp_ok, cmp = pcall(require, "cmp")
			local cmp_autopairs_ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
			if cmp_ok and cmp_autopairs_ok then
				cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
			end
		end,
	})
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})

	-- LSP
	use("neovim/nvim-lspconfig")
	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-nvim-lsp")
	use("nvim-lua/lsp-status.nvim") -- Puedes considerar eliminarlo si Lualine es suficiente

	-- UI / UX
	use("nvim-telescope/telescope.nvim")
	use("nvim-telescope/telescope-ui-select.nvim")
	use("nvim-telescope/telescope-file-browser.nvim")
	use("rcarriga/nvim-notify")
	use("stevearc/dressing.nvim")
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- Pega aquí tu configuración de lualine.lua si la tenías separada
			require("lualine").setup({
				options = {
					theme = "auto",
					section_separators = { left = "", right = "" },
					component_separators = { left = "", right = "" },
					icons_enabled = true,
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff" },
					lualine_c = { { "filename", path = 1 }, { "diagnostics", sources = { "nvim_lsp" } } },
					lualine_x = { "filetype", "encoding", "fileformat" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	})
	use("echasnovski/mini.icons")
	use({
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
			require("which-key").setup({})
		end,
	})
	use({
		"glepnir/dashboard-nvim",
		requires = { "nvim-tree/nvim-web-devicons" },
	})
	use({
		"gen740/SmoothCursor.nvim",
		config = function()
			require("smoothcursor").setup()
		end,
	})
	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("ibl").setup()
		end,
	})
	use({
		"folke/trouble.nvim",
		requires = "nvim-tree/nvim-web-devicons",
		config = function()
			require("trouble").setup()
		end,
	})
	use({
		"akinsho/toggleterm.nvim",
		tag = "*",
		config = function()
			-- Pega aquí tu configuración de toggleterm (de keymaps/terminal.lua)
			require("toggleterm").setup({
				size = function(term)
					if term.direction == "horizontal" then
						return vim.o.lines * 0.4
					end
					if term.direction == "vertical" then
						return vim.o.columns * 0.4
					end
				end,
				direction = "float",
				float_opts = { border = "curved", winblend = 3 },
				-- ... otras opciones que tenías ...
			})
		end,
	})
	use({
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("neo-tree").setup({
				close_if_last_window = true,
				popup_border_style = "rounded",
				enable_git_status = true,
				enable_diagnostics = true,
				filesystem = {
					filtered_items = { visible = true, hide_dotfiles = false, hide_gitignored = true },
					follow_current_file = true,
					hijack_netrw_behavior = "open_current",
					use_libuv_file_watcher = true,
				},
				window = { position = "left", width = 30, mappings = { ["H"] = "toggle_hidden" } },
			})
		end,
	})

	-- Git
	use("tpope/vim-fugitive")
	use("lewis6991/gitsigns.nvim")
	use({
		"NeogitOrg/neogit",
		requires = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim", "nvim-telescope/telescope.nvim" },
		config = function()
			require("neogit").setup({ integrations = { telescope = true, diffview = true } })
		end,
	})
	use("sindrets/diffview.nvim")

	-- Testing
	use({
		"nvim-neotest/neotest",
		requires = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter", "antoinemadec/FixCursorHold.nvim" },
	})

	-- Lenguajes Específicos
	use("akinsho/flutter-tools.nvim")

	-- Temas
	use({ "dracula/vim", as = "dracula" })
	use("tomasr/molokai")
	use("altercation/vim-colors-solarized")
	use("joshdick/onedark.vim")
	use("morhetz/gruvbox")
	use({ "rose-pine/neovim", as = "rose-pine" })

	-- Otros
	use("preservim/tagbar")
	use({
		"iamcco/markdown-preview.nvim",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
		ft = "markdown",
	})
	use("junegunn/fzf", {
		run = function()
			vim.fn["fzf#install"]()
		end,
	})
	use("junegunn/fzf.vim")

	-- Sincronizar al final si es el primer inicio
	if packer_bootstrap then
		require("packer").sync()
	end
end) -- Fin de packer.startup
