# Neovim + Vim + IntelliJ Configuration

Cross-platform (macOS / Linux / Windows) development environment with synchronized keybindings across Neovim, Vim, and JetBrains IDEs.

**Requires Neovim 0.12+** | Updated September 2026 (Windows / macOS / Linux)

## Features

- **Neovim 0.12 native APIs** - Uses `vim.lsp.config()` / `vim.lsp.enable()`, `vim.treesitter.start()`, modern diagnostics
- **lazy.nvim** (~79 specs, ~10 load at idle startup)
- **IdeaVim** config (`.ideavimrc`) shares the same leader **prefixes**; AI CLIs and CopilotChat are Neovim-only
- **Legacy Vim** config (`.vimrc`) with vim-plug (`~/vimfiles` on Windows, `~/.vim` on Unix)
- **Cross-platform** — shells, paths, builds and CLIs are guarded (`win32` / `executable` / `os_homedir`)
- **Keymaps** — runtime-audited: no two actions share the same mode+key. Prefix delays (`<leader>f` vs `<leader>ff`) wait `timeoutlen=300` by design

## Stack decisions (researched, September 2026)

| Choice | Why this one |
|--------|--------------|
| `mason-org/mason.nvim` + `mason-lspconfig` | Upstream moved `williamboman/*` → `mason-org/*` (v2.x, actively maintained) |
| `nvimtools/none-ls.nvim` (kept) | Community-maintained null-ls successor (not archived); covers formatting + code actions in one client |
| `nvim-cmp` + LuaSnip (kept) | Pure Lua, stable, validated conflict-free; `blink.cmp` needs a Rust toolchain and moves fast — not worth the churn |
| `github/copilot.vim` + CopilotChat | Official inline client + best-rated chat UI; AI CLIs (`<leader>a*`) cover agentic work with their own subscriptions |
| `telescope.nvim` pinned `v0.2.2` | Latest tag; `file-browser` extension removed (never loaded — neo-tree + oil cover it) |
| Single icon provider | `nvim-web-devicons` only (`mini.icons` removed, nothing used it) |

## Requirements

| Tool | Why | Install |
|------|-----|---------|
| Neovim 0.12+ | Editor | Windows: `winget install Neovim.Neovim` · macOS: `brew install neovim` · Linux: distro package or [release](https://github.com/neovim/neovim/releases) |
| Git | Plugins, LSP updates | Preinstalled on macOS/Linux; Windows: `winget install Git.Git` |
| Node.js 22+ | Copilot, Mason packages | [nodejs.org](https://nodejs.org) or `winget install OpenJS.NodeJS` / `brew install node` |
| C compiler | Treesitter parsers, LuaSnip build | Windows: Visual Studio Build Tools · macOS: `xcode-select --install` · Linux: `gcc` |
| Nerd Font | File/UI icons | Windows: `winget install DEVCOM.JetBrainsMonoNerdFont` then set terminal font to **JetBrainsMono NFM**. macOS: `brew install --cask font-jetbrains-mono-nerd-font`. Linux: install from [nerdfonts.com](https://www.nerdfonts.com). Without this, Telescope/neo-tree show empty boxes. |
| ripgrep + fd | Fast search (recommended) | `winget install BurntSushi.ripgrep.MSVC sharkdp.fd` · `brew install ripgrep fd` · `apt install ripgrep fd-find` |
| tree-sitter CLI | Parser compilation | `npm install -g tree-sitter-cli` |
| AI CLIs (optional) | `<leader>a*` terminals | npm: `opencode-ai`, `@openai/codex`, `@anthropic-ai/claude-code`, `@google/gemini-cli`, `@github/copilot`. Grok: xAI CLI on PATH (not npm). Each keeps its own login. |
| uv (Windows, optional) | `black` / `clang-format` | `winget install astral-sh.uv` then `uv tool install black clang-format` |

Mason self-installs: `lua_ls`, `clangd`, `jsonls`, `yamlls`, `gopls`, `pyright`, `vtsls`, `astro`, `intelephense`, `bashls`, `dockerls`, `html`, `cssls`, `taplo`, plus formatters `stylua` and `prettier`. Dart LSP comes from **flutter-tools** (Flutter SDK). On Windows, `black` and `clang-format` need `uv tool install black clang-format`.

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

# Install tree-sitter CLI (required for treesitter parser compilation)
npm install -g tree-sitter-cli

# Launch Neovim - plugins install automatically
nvim
```

### Windows

```powershell
git clone git@github.com:chochy2001/Neovim-Vim_Configuration.git $HOME\Neovim-Vim_Configuration
New-Item -ItemType Junction -Path "$env:LOCALAPPDATA\nvim" -Target "$HOME\Neovim-Vim_Configuration\.config\nvim"
Copy-Item "$HOME\Neovim-Vim_Configuration\.ideavimrc" "$HOME\.ideavimrc"
```

## How to use

Leader is **Space**. After Space, wait ~300 ms or keep typing the rest of the shortcut. Press Space again (`<leader><leader>`) to clear search highlight — that is **not** find-files.

**First launch:** open a terminal, run `nvim` with no file. The CAPDESIS dashboard appears (only when you did not pass a path). Plugins install on their own; Mason installs LSPs/formatters in the background.

| Dashboard key | Action |
|---------------|--------|
| `f` | Find file |
| `g` | Live grep |
| `r` | Recent files |
| `e` | File explorer (neo-tree) |
| `a` | AI terminal (opencode) |
| `m` | Mason (LSP installer) |
| `l` | Lazy (plugins) |
| `q` | Quit |

**Every day**

1. `nvim` in a project (or `nvim path/to/file`).
2. `<leader>ff` find a file, `<leader>fg` search text, `<leader>pv` tree.
3. Edit. LSP starts when the language binary exists (statusline shows `dartls`, `gopls`, …).
4. `<leader>fm` format. `gd` go to definition, `<leader>ca` code action, `<leader>rn` rename.
5. Git: `<leader>gs` status → `<leader>gsa` stage hunk → `<leader>gc` commit → `<leader>gp` push.
6. AI: visual-select code → `<leader>as` → pick agent → type what to change. Or `<leader>aa` for opencode.

**Commands (type `:` then the name)**

| Command | What it does |
|---------|----------------|
| `:Telescope keymaps` | **Live list of every shortcut** (source of truth) |
| `:Lazy` | Plugin manager |
| `:Mason` | Install/update LSP servers and formatters |
| `:checkhealth` | Diagnose Neovim |
| `:checkhealth vim.lsp` | Active language servers |
| `:CopilotChat` | Copilot chat |
| `:LspRestartDart` | Restart Dart LSP |
| `:LspStatus` | List LSP clients |
| `:CheckFormatters` | List none-ls formatters |
| `:Neotree` / `:Oil` | File tree / directory editor |
| `:DiffviewOpen` | Git diff UI |
| `:ZenMode` | Focus mode |
| `:GrugFar` | Project search-replace |
| `:SwaggerPreview` | OpenAPI preview (if you have the CLI) |

Full tables: [WORKFLOW.md](WORKFLOW.md). For AI agents extending this repo: [AGENTS.md](AGENTS.md).

**Cómo usarlo (ES):** Leader = **Espacio**. `nvim` sin archivo abre el dashboard CAPDESIS (`f` buscar, `g` grep, `e` explorador, `a` IA, `q` salir). Cada día: `<leader>ff` archivo, `<leader>fg` texto, `<leader>fm` formatear, `gd` ir a definición. Git: `<leader>gs` → `<leader>gsa` → `<leader>gc` → `<leader>gp`. Lista viva de atajos: `:Telescope keymaps`.

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
| `<leader>gsu` | Undo stage hunk |
| `<leader>gsp` | Preview hunk |
| `<leader>gdo` | Open diffview |
| `<leader>gdq` | Close diffview |
| `<leader>gco` | Conflict: choose ours |
| `<leader>gct` | Conflict: choose theirs |
| `<leader>gcb` | Conflict: choose both |

### LSP & Code Intelligence

| Key | Action |
|-----|--------|
| `gd` | Go to definition (native 0.11+) |
| `gi` | Go to implementation (native 0.11+) |
| `gR` | Find references (Trouble) |
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

### Diagnostics (Trouble v3)

| Key | Action |
|-----|--------|
| `<leader>xx` | Toggle diagnostics |
| `<leader>xX` | Buffer diagnostics |
| `<leader>xw` | Workspace diagnostics |
| `<leader>xd` | Document diagnostics |
| `<leader>xl` | Location list |
| `<leader>xq` | Quickfix list |
| `<leader>xn` | Next error |
| `<leader>xp` | Previous error |
| `<leader>xt` | TODOs list |
| `gR` | LSP references |

### File Explorer

| Key | Action |
|-----|--------|
| `<leader>pv` | Toggle neo-tree |
| `<leader>fr` | Reveal current file |
| `<leader>-` / `<leader>oe` | Oil (edit directory as a buffer) |
| `<leader>tb` | Tagbar (needs `ctags` on PATH) |

### Terminal & Tasks

| Key | Action |
|-----|--------|
| `<leader>tt` | Float terminal |
| `<leader>tg` | LazyGit |
| `<leader>tn` | Node REPL |
| `<leader>tp` | Python REPL |
| `<leader>tu` | System monitor |
| `<leader>tF` | Flutter terminal |
| `<leader>r` | Run code |
| `<leader>rf` | Run file |
| `<leader>rp` | Run project |
| `<leader>rs` | Stop |
| `<leader>rb` | Build |
| `<leader>oo` | Overseer toggle |
| `<leader>or` | Overseer run task |
| `<leader>ob` | Overseer build |
| `<leader>oi` | Overseer info |

### Testing (vim-test)

| Key | Action |
|-----|--------|
| `<leader>ten` | Test nearest |
| `<leader>tenf` | Test file |
| `<leader>tena` | Test suite |
| `<leader>tenl` | Rerun last |

### Sessions

| Key | Action |
|-----|--------|
| `<leader>qs` | Restore session |
| `<leader>ql` | Restore last session |
| `<leader>qd` | Don't save session |

### AI Assistants (terminal CLIs + Copilot)

| Key | Action |
|-----|--------|
| `<leader>aa` | opencode terminal |
| `<leader>ax` | codex terminal |
| `<leader>ac` | claude terminal |
| `<leader>ag` | gemini terminal |
| `<leader>ak` | grok terminal |
| `<leader>ap` | copilot CLI terminal |
| `<leader>as` (visual) | Send selection to any agent (picker) |
| `<leader>cc` | Copilot chat toggle |
| `<leader>ce` | Explain (normal/visual) |
| `<leader>cr` | Review (normal/visual) |
| `<leader>cf` | Fix (normal/visual) |
| `<leader>co` | Optimize (normal/visual) |
| `<leader>ct` | Generate tests (normal/visual) |

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
| `<leader>flc` | Clear log |
| `<leader>flp` | Copy profiler URL |
| `<leader>fll` | Restart LSP |

### Buffer & Window Management

| Key | Action |
|-----|--------|
| `<leader>b` | Back (previous location) |
| `<leader>bn` | Next buffer |
| `<leader>bp` | Previous buffer |
| `<leader>bd` | Close buffer |
| `<leader>bl` | Close buffers to the right |
| `<leader>bh` | Close buffers to the left |
| `<leader>bP` | Pick buffer |
| `<leader>bt` | Toggle pin buffer |
| `<leader>to` | Close all other buffers |
| `<S-l>` / `<S-h>` | Next / previous buffer |
| `<leader>sv` | Split vertical |
| `<leader>sh` | Split horizontal |
| `<leader>sc` | Close split |
| `<leader>wh/j/k/l` | Navigate windows |
| `<leader>wm` | Move window (WinShift) |
| `<leader>ws` | Swap window |
| `<leader>zz` | Zen mode |

### Core Editing

| Key | Action |
|-----|--------|
| `s` | Flash jump (n/v/o) |
| `S` | Flash treesitter (n/o); visual `S` = surround |
| `jj` | Exit insert mode |
| `<leader><leader>` | Clear search highlight |
| `<A-j>` / `<A-k>` | Move line down/up |
| `n` / `N` | Search next/prev (centered) |
| `<leader>za` | Toggle fold |
| `<leader>zR` / `<leader>zM` | Expand/collapse all folds |
| `<leader>u` | Normal: undo tree · Visual: lowercase |
| `<leader>U` (visual) | To uppercase |
| `<leader>sr` | Search and replace (grug-far) |

## Plugin Ecosystem

| Category | Plugins |
|----------|---------|
| **Package Manager** | lazy.nvim |
| **LSP** | nvim-lspconfig (lsp/ defs), vim.lsp.config(), none-ls, schemastore |
| **Completion** | nvim-cmp, LuaSnip, friendly-snippets |
| **Syntax** | nvim-treesitter (parser manager), vim.treesitter.start(), treesitter-context |
| **Git** | fugitive, gitsigns, diffview, neogit, git-conflict |
| **Navigation** | telescope, harpoon, neo-tree, oil |
| **UI** | lualine, bufferline, dashboard (CAPDESIS), dropbar, nvim-highlight-colors, dressing, nvim-notify, which-key, indent-blankline |
| **Editing** | Comment.nvim, vim-surround, nvim-autopairs, todo-comments, flash.nvim |
| **Text Objects** | nvim-treesitter-textobjects (function, class, argument, loop, conditional) |
| **LSP Management** | mason.nvim, mason-lspconfig (auto-install servers), mason-tool-installer (auto-install formatters) |
| **LSP UI** | fidget.nvim (progress), noice.nvim (modern command line) |
| **AI** | copilot.vim, CopilotChat.nvim, AI terminal CLIs (opencode, codex, claude, gemini, grok, copilot) |
| **Debugging** | nvim-dap, nvim-dap-ui, nvim-dap-virtual-text |
| **Folding** | nvim-ufo (treesitter-based smart folding) |
| **Flutter** | flutter-tools, dart-vim-plugin, awesome-flutter-snippets |
| **Terminal** | toggleterm, overseer, code_runner, vim-test |
| **Themes** | dracula, molokai, solarized, onedark, gruvbox, rose-pine, catppuccin |
| **Focus** | zen-mode, twilight |
| **Other** | undotree, trouble, grug-far, winshift, persistence, project.nvim, tagbar, swagger-preview |

## What this config is for

Built around the CAPDESIS / personal GitHub stack (Flutter apps, Go APIs, Astro landings, PHP backends, Python, Kotlin, C). Open any of those repos and the matching LSP/formatter attaches when the binary exists.

| Product area | Languages |
|--------------|-----------|
| Tracker, CapTienda, CapMenu, CapLiving, CapGym, Formulae, photos_class, … | Dart / Flutter |
| IngeTracker, POS, CapLiving, CapGym, billing, academy, ancare, … | Go |
| capdesis-web, landings, leon-entertainment, xunkaab, … | Astro / TypeScript |
| CapMenu, Opus, GestionInventarioQR | PHP |
| Distributed_System, scripts, tooling | Python |
| Android embeddings (CapGym, etc.) | Kotlin |
| 2027-1 / firmware notes | C / C++ |

## Languages Supported

| Language | LSP | Formatter | Extras |
|----------|-----|-----------|--------|
| Lua | lua_ls | stylua | Neovim runtime integration |
| Dart/Flutter | dartls (flutter-tools) | `<leader>fm` / none-ls | outline, snippets, DAP |
| Go | gopls | gofmt | staticcheck, gofumpt |
| Python | pyright | black (`uv tool install black`) | openFiles diagnostics |
| TypeScript/JavaScript | vtsls | prettier | - |
| Astro | astro | prettier | Pinned to Mason copy (ignores broken project-local installs) |
| JSON | jsonls | prettier | SchemaStore integration |
| YAML | yamlls | prettier | pubspec.yaml schemas |
| C/C++ | clangd | clang-format | Header insertion, clang-tidy |
| Kotlin | kotlin_language_server | - | Gradle project detection (needs `gradle` on PATH for full classpath) |
| Swift | sourcekit-lsp (macOS) | - | - |
| HTML / CSS | html, cssls | prettier | landings + Flutter web |
| PHP | intelephense | — | CapMenu / Opus / Inventario QR backends |
| Bash | bashls | — | fleet `.sh` scripts |
| Docker | dockerls | — | Dockerfiles across products |
| TOML | taplo | prettier | pyproject, Cargo, tool configs |
| SQL | — | — | Treesitter highlighting |

## IdeaVim (IntelliJ / Android Studio)

Official plugin: [IdeaVim](https://plugins.jetbrains.com/plugin/164-ideavim). Config file is **`~/.ideavimrc`** on every OS (Windows: `%USERPROFILE%\.ideavimrc`). XDG: `$XDG_CONFIG_HOME/ideavim/ideavimrc`.

1. Settings → Plugins → install **IdeaVim** → **Tools | Vim**.
2. Copy this repo’s `.ideavimrc` to `~/.ideavimrc` (do **not** `source` the classic `.vimrc` — it uses vim-plug).
3. Reload: `:source ~/.ideavimrc`.
4. Unknown action IDs: `:actionlist <pattern>` or Search Everywhere → **IdeaVim: track action IDs**.

IDE mappings use `nmap … <Action>(id)` ([required](https://github.com/JetBrains/ideavim#executing-ide-actions); `nnoremap` + `:action` does not work). Same leader prefixes as Neovim. **Neovim-only:** `<leader>a*` AI CLIs, `<leader>c*` CopilotChat. Flutter keys need the [Flutter plugin](https://plugins.jetbrains.com/plugin/9212-flutter). IdeaVim cannot be GUI-tested from this repo’s CLI — confirm inside the IDE.

- `<leader>f*` - Find/search
- `<leader>g*` - Git (IDE VCS)
- `<leader>fl*` - Flutter (plugin)
- `<leader>x*` - Problems tool window
- `<leader>m*` - Bookmarks
- `<leader>b*` - Tabs (`<leader>b` alone = Back, same 300 ms prefix as Neovim)
- `<leader>w*` - Windows
- `<leader>t*` - Terminal
- `<leader>r*` - Run
- `<leader>z*` - Fold / distraction-free
- `<leader>d*` - Debug
- `<leader>o*` - Run tool window / Run Anything

## File Structure

```
.
├── .config/nvim/
│   ├── init.lua                          # Entry point (lazy.nvim bootstrap)
│   ├── lazy-lock.json                    # Plugin version lock file
│   ├── lua/
│   │   ├── vim-options.lua               # Core vim settings & keymaps
│   │   ├── lsp-utils.lua                 # LSP helper commands
│   │   ├── fix-flutter-neotree-conflict.lua  # Dart LSP dedup
│   │   ├── plugins.lua                   # Lazy.nvim plugin loader
│   │   └── plugins/                      # 28 plugin config files
│   │       ├── lsp-config.lua            # vim.lsp.config() + vim.lsp.enable()
│   │       ├── treesitter.lua            # Parser management + TS highlighting
│   │       ├── telescope.lua             # Fuzzy finder (v0.2.2, latest)
│   │       ├── completions.lua           # nvim-cmp + LuaSnip
│   │       ├── git-stuff.lua             # Fugitive, gitsigns, diffview, neogit
│   │       ├── trouble.lua               # Diagnostics list (Trouble v3)
│   │       ├── ai-terminal.lua           # AI CLIs in floating terminals
│   │       └── ...                       # remaining specs (28 files total)
│   ├── README.md                         # Detailed nvim-specific docs
├── .ideavimrc                            # JetBrains IDE config (synced)
├── .vimrc                                # Legacy Vim config
├── WORKFLOW.md                           # Full keymap-by-keymap workflow guide
├── AGENTS.md                             # How to extend this config (EN + ES)
└── .gitignore
```

## License

MIT
