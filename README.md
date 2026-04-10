# Neovim + Vim + IntelliJ Configuration

Cross-platform (macOS / Linux / Windows) development environment with synchronized keybindings across Neovim, Vim, and JetBrains IDEs.

## Features

- **Neovim** config with [lazy.nvim](https://github.com/folke/lazy.nvim), native LSP, and 60+ plugins
- **IdeaVim** config (`.ideavimrc`) fully synchronized with Neovim keybindings
- **Legacy Vim** config (`.vimrc`) with vim-plug
- **Cross-platform** - all paths dynamically detected, works on macOS, Linux, and Windows
- **Zero conflicts** - all keybindings audited, no overlaps between plugins

## Quick Install

```bash
# Clone the repository
git clone git@github.com:chochy2001/Neovim-Vim_Configuration.git ~/Neovim-Vim_Configuration

# Symlink Neovim config
mkdir -p ~/.config
ln -sfn ~/Neovim-Vim_Configuration/.config/nvim ~/.config/nvim

# Symlink IdeaVim config
ln -sf ~/Neovim-Vim_Configuration/.ideavimrc ~/.ideavimrc

# (Optional) Symlink legacy Vim config
ln -sf ~/Neovim-Vim_Configuration/.vimrc ~/.vimrc

# Launch Neovim - plugins install automatically
nvim
```

### Windows

```powershell
git clone git@github.com:chochy2001/Neovim-Vim_Configuration.git $HOME\Neovim-Vim_Configuration
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\nvim" -Target "$HOME\Neovim-Vim_Configuration\.config\nvim"
Copy-Item "$HOME\Neovim-Vim_Configuration\.ideavimrc" "$HOME\_ideavimrc"
```

## Keybinding System

Leader key: `Space`

### Find & Search (Telescope)

| Key | Action | IdeaVim Equivalent |
|-----|--------|--------------------|
| `<leader>ff` | Find files | `GotoFile` |
| `<leader>fg` | Live grep | `FindInPath` |
| `<leader>fo` | Recent files | `RecentFiles` |
| `<leader>fb` | Buffers | `Switcher` |
| `<leader>fh` | Help tags | `HelpTopics` |
| `<leader>fc` | Commands | `GotoAction` |
| `<leader>fk` | Keymaps | `GotoAction` |
| `<leader>ps` | Workspace symbols | `GotoSymbol` |
| `<leader>fp` | Projects | `ManageRecentProjects` |

### Git Operations

| Key | Action |
|-----|--------|
| `<leader>gs` | Git status |
| `<leader>gc` | Git commit |
| `<leader>gp` | Git push |
| `<leader>gl` | Git pull |
| `<leader>gf` | Git fetch |
| `<leader>gb` | Git blame toggle |
| `<leader>gd` | Git diff |
| `<leader>gn` | Next hunk |
| `<leader>gnp` | Previous hunk |
| `<leader>gsa` | Stage hunk |
| `<leader>gsr` | Reset hunk |
| `<leader>gdo` | Open diffview |
| `<leader>gdq` | Close diffview |
| `<leader>gco` | Conflict: choose ours |
| `<leader>gct` | Conflict: choose theirs |
| `<leader>gcb` | Conflict: choose both |

### LSP & Code Intelligence

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gi` | Go to implementation |
| `gr` | Find references |
| `go` | Go to type definition |
| `gs` | Signature help |
| `K` | Hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>fm` | Format document |

### Harpoon (Quick Marks)

| Key | Action |
|-----|--------|
| `<leader>ma` | Add file to harpoon |
| `<leader>mh` | Toggle harpoon UI |
| `<leader>1-9` | Jump to mark 1-9 |
| `<leader>mp` | Previous mark |
| `<leader>mn` | Next mark |

### Debugging (DAP)

| Key | Action |
|-----|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Continue / start |
| `<leader>do` | Step over |
| `<leader>di` | Step into |
| `<leader>dO` | Step out |
| `<leader>du` | Toggle debug UI |
| `<leader>dx` | Terminate |

### Diagnostics (Trouble)

| Key | Action |
|-----|--------|
| `<leader>xx` | Toggle trouble |
| `<leader>xw` | Workspace diagnostics |
| `<leader>xd` | Document diagnostics |
| `<leader>xn` | Next error |
| `<leader>xp` | Previous error |
| `<leader>xt` | TODOs list |

### File Explorer

| Key | Action |
|-----|--------|
| `<leader>pv` | Toggle neo-tree |
| `<leader>fr` | Reveal current file |
| `<leader>-` | Oil (edit directory) |

### Terminal & Tasks

| Key | Action |
|-----|--------|
| `<leader>tt` | Float terminal |
| `<leader>tg` | LazyGit |
| `<leader>tn` | Node REPL |
| `<leader>tp` | Python REPL |
| `<leader>r` | Run code |
| `<leader>rf` | Run file |
| `<leader>rp` | Run project |
| `<leader>rs` | Stop |
| `<leader>rb` | Build |

### Copilot Chat (AI)

| Key | Action |
|-----|--------|
| `<leader>cc` | Toggle chat |
| `<leader>ce` | Explain code |
| `<leader>cr` | Review code |
| `<leader>cf` | Fix code |
| `<leader>co` | Optimize code |
| `<leader>ct` | Generate tests |

### Flutter Development

| Key | Action |
|-----|--------|
| `<leader>flr` | Hot reload |
| `<leader>fls` | Hot restart |
| `<leader>fld` | DevTools |
| `<leader>fla` | Run app |
| `<leader>flsd` | Select device |
| `<leader>fle` | Start emulator |
| `<leader>flq` | Quit |
| `<leader>flo` | Toggle outline |

### Buffer & Window Management

| Key | Action |
|-----|--------|
| `<leader>bn` | Next buffer |
| `<leader>bp` | Previous buffer |
| `<leader>bd` | Close buffer |
| `<S-l>` / `<S-h>` | Next / previous buffer |
| `<leader>sv` | Split vertical |
| `<leader>sh` | Split horizontal |
| `<leader>sc` | Close split |
| `<leader>wh/j/k/l` | Navigate windows |
| `<leader>zz` | Zen mode |

### Core Editing

| Key | Action |
|-----|--------|
| `jj` | Exit insert mode |
| `<leader><leader>` | Clear search highlight |
| `<A-j>` / `<A-k>` | Move line down/up |
| `n` / `N` | Search next/prev (centered) |
| `<leader>za` | Toggle fold |
| `<leader>zR` / `<leader>zM` | Expand/collapse all folds |
| `<leader>u` (visual) | To lowercase |
| `<leader>U` (visual) | To uppercase |

## Plugin Ecosystem

| Category | Plugins |
|----------|---------|
| **Package Manager** | lazy.nvim |
| **LSP** | nvim-lspconfig, none-ls, schemastore |
| **Completion** | nvim-cmp, LuaSnip, friendly-snippets |
| **Syntax** | nvim-treesitter, treesitter-context, rainbow-delimiters |
| **Git** | fugitive, gitsigns, diffview, neogit, git-conflict |
| **Navigation** | telescope, harpoon, neo-tree, oil |
| **UI** | lualine, bufferline, dashboard, dressing, nvim-notify, which-key, indent-blankline |
| **Editing** | Comment.nvim, vim-surround, nvim-autopairs, todo-comments |
| **AI** | copilot.vim, CopilotChat.nvim |
| **Debugging** | nvim-dap, nvim-dap-ui, nvim-dap-virtual-text |
| **Folding** | nvim-ufo (treesitter-based smart folding) |
| **Flutter** | flutter-tools, dart-vim-plugin, awesome-flutter-snippets |
| **Terminal** | toggleterm, overseer, code_runner |
| **Themes** | dracula, gruvbox, catppuccin, onedark, rose-pine, solarized |
| **Focus** | zen-mode, twilight |
| **Other** | undotree, trouble, grug-far, winshift, persistence, project.nvim |

## Languages Supported

| Language | LSP | Formatter | Extras |
|----------|-----|-----------|--------|
| Lua | lua_ls | stylua | Neovim runtime integration |
| Dart/Flutter | dartls | dart_format | flutter-tools, snippets, DAP |
| C/C++ | clangd | clang-format | Header insertion, clang-tidy |
| Swift | sourcekit-lsp (macOS) | - | - |
| Kotlin | kotlin_language_server | - | Gradle project detection |
| JSON | jsonls | prettier | SchemaStore integration |
| YAML | yamlls | prettier | pubspec.yaml schemas |
| Web (JS/TS/HTML/CSS) | - | prettier | - |

## IdeaVim Synchronization

The `.ideavimrc` is fully synchronized with the Neovim config. All keybindings use the same prefixes:

- `<leader>f*` - Find/search
- `<leader>g*` - Git operations
- `<leader>fl*` - Flutter
- `<leader>x*` - Diagnostics
- `<leader>m*` - Marks/harpoon
- `<leader>b*` - Buffers
- `<leader>w*` - Windows
- `<leader>r*` - Run/debug
- `<leader>z*` - Folding/zen
- `<leader>c*` - Copilot chat
- `<leader>q*` - Sessions

## File Structure

```
.
├── .config/nvim/
│   ├── init.lua              # Entry point (lazy.nvim bootstrap)
│   ├── lua/
│   │   ├── vim-options.lua   # Core vim settings & keymaps
│   │   ├── lsp-utils.lua     # LSP helper functions
│   │   └── plugins/          # Plugin configs (one per file)
│   │       ├── lsp-config.lua
│   │       ├── completions.lua
│   │       ├── telescope.lua
│   │       ├── neo-tree.lua
│   │       ├── git-stuff.lua
│   │       ├── github-copilot.lua  # Copilot + CopilotChat
│   │       ├── flutter-tools.lua
│   │       ├── terminal.lua
│   │       └── ...
│   └── README.md
├── .ideavimrc                # JetBrains IDE config (synced)
├── .vimrc                    # Legacy Vim config
└── .gitignore
```

## License

MIT
